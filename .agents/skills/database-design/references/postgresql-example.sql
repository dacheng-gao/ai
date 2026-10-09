-- Teaching fixture: execute only in a fresh isolated PostgreSQL database.
\set ON_ERROR_STOP on
CREATE EXTENSION btree_gist;

CREATE TABLE dd_tenant (
    id bigint PRIMARY KEY
);
CREATE TABLE dd_resource (
    tenant_id bigint NOT NULL REFERENCES dd_tenant(id),
    id bigint GENERATED ALWAYS AS IDENTITY,
    code text NOT NULL CHECK (length(code) > 0),
    PRIMARY KEY (tenant_id, id),
    UNIQUE (tenant_id, code)
);
CREATE TABLE dd_booking (
    tenant_id bigint NOT NULL,
    id bigint GENERATED ALWAYS AS IDENTITY,
    resource_id bigint NOT NULL,
    starts_at timestamptz NOT NULL,
    ends_at timestamptz NOT NULL,
    status text NOT NULL CHECK (status IN ('booked', 'cancelled')),
    PRIMARY KEY (tenant_id, id),
    FOREIGN KEY (tenant_id, resource_id)
        REFERENCES dd_resource(tenant_id, id),
    CHECK (isfinite(starts_at) AND isfinite(ends_at) AND starts_at < ends_at),
    EXCLUDE USING gist (
        tenant_id WITH =, resource_id WITH =,
        tstzrange(starts_at, ends_at, '[)') WITH &&
    ) WHERE (status = 'booked')
);
CREATE INDEX dd_booking_booked_list
    ON dd_booking (tenant_id, starts_at, id) WHERE status = 'booked';
-- Include cancelled history in the resource-reference access path as well.
CREATE INDEX dd_booking_resource_fk ON dd_booking (tenant_id, resource_id);

INSERT INTO dd_tenant VALUES (1), (2);
INSERT INTO dd_resource (tenant_id, code) VALUES (1, 'R1'), (2, 'R1');
INSERT INTO dd_booking (tenant_id, resource_id, starts_at, ends_at, status) VALUES
    (1, 1, '2026-10-10 09:00+00', '2026-10-10 10:00+00', 'booked'),
    (1, 1, '2026-10-10 10:00+00', '2026-10-10 11:00+00', 'booked'),
    (1, 1, '2026-10-10 09:00+00', '2026-10-10 10:00+00', 'cancelled');

-- Assert exact error categories without hiding unexpected failures.
CREATE FUNCTION pg_temp.expect_state(command text, expected text)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE actual text;
BEGIN
    BEGIN
        EXECUTE command;
    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS actual = RETURNED_SQLSTATE;
    END;
    IF actual IS DISTINCT FROM expected THEN
        RAISE EXCEPTION 'expected SQLSTATE %, got %: %', expected, actual, command;
    END IF;
END;
$$;

SELECT pg_temp.expect_state($q$
    INSERT INTO dd_booking (tenant_id, resource_id, starts_at, ends_at, status)
    VALUES (1, 1, '2026-10-10 09:30+00', '2026-10-10 10:30+00', 'booked')
$q$, '23P01');
SELECT pg_temp.expect_state($q$
    INSERT INTO dd_booking (tenant_id, resource_id, starts_at, ends_at, status)
    VALUES (2, 1, '2026-10-10 12:00+00', '2026-10-10 13:00+00', 'booked')
$q$, '23503');
SELECT pg_temp.expect_state($q$
    INSERT INTO dd_booking (tenant_id, resource_id, starts_at, ends_at, status)
    VALUES (1, 1, '2026-10-10 12:00+00', '2026-10-10 12:00+00', 'booked')
$q$, '23514');
SELECT pg_temp.expect_state($q$
    INSERT INTO dd_booking (tenant_id, resource_id, starts_at, ends_at, status)
    VALUES (1, 1, NULL, '2026-10-10 13:00+00', 'booked')
$q$, '23502');
SELECT pg_temp.expect_state($q$
    INSERT INTO dd_booking (tenant_id, resource_id, starts_at, ends_at, status)
    VALUES (1, 1, '2026-10-10 12:00+00', 'infinity', 'booked')
$q$, '23514');
SELECT pg_temp.expect_state($q$
    INSERT INTO dd_resource (tenant_id, code) VALUES (1, 'R1')
$q$, '23505');
SELECT pg_temp.expect_state($q$DELETE FROM dd_resource WHERE tenant_id = 1 AND id = 1$q$, '23503');

UPDATE dd_booking SET status = 'cancelled' WHERE tenant_id = 1 AND id = 1;
INSERT INTO dd_booking (tenant_id, resource_id, starts_at, ends_at, status)
VALUES (1, 1, '2026-10-10 09:00+00', '2026-10-10 10:00+00', 'booked');

DO $$
BEGIN
    IF (SELECT count(*) FROM dd_booking) <> 4
       OR (SELECT count(*) FROM dd_booking WHERE status = 'cancelled') <> 2
       OR (SELECT count(*) FROM dd_booking WHERE status = 'booked') <> 2 THEN
        RAISE EXCEPTION 'unexpected committed teaching-fixture state';
    END IF;
END;
$$;
SELECT 'teaching fixture integrity checks passed' AS result;
