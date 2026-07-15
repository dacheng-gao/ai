#!/usr/bin/env bash

set -u

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

failures=0

fail() {
    printf 'FAIL: %s\n' "$1" >&2
    failures=$((failures + 1))
}

require_file() {
    [ -f "$1" ] || fail "missing required file: $1"
}

for path in \
    AGENTS.md \
    CLAUDE.md \
    rules/engineering.md \
    rules/communication.md \
    scripts/obsolete-paths.txt; do
    require_file "$path"
done

[ ! -e prompts ] || fail "legacy task-prompt builders remain: prompts"

expected_skills=(
    answer
    architecture-review
    develop-feature
    fix-bug
    git
    github
    refactor
    review-code
    reviewing-product-requirements
    superagents
    writing-test-cases
)

for skill in "${expected_skills[@]}"; do
    require_file "skills/$skill/SKILL.md"
done

while IFS= read -r path; do
    [ -n "$path" ] || continue
    case "$path" in
        /*|..|../*|*/..|*/../*)
            fail "unsafe obsolete manifest path: $path"
            continue
            ;;
    esac
    [ ! -e "$path" ] || fail "obsolete managed path remains: $path"
done < scripts/obsolete-paths.txt

while IFS= read -r skill_file; do
    skill_dir="$(basename "$(dirname "$skill_file")")"
    first_line="$(sed -n '1p' "$skill_file")"
    [ "$first_line" = "---" ] || fail "$skill_file must start with frontmatter"

    closing_line="$(awk 'NR > 1 && $0 == "---" { print NR; exit }' "$skill_file")"
    if [ -z "$closing_line" ]; then
        fail "$skill_file has invalid frontmatter"
        continue
    fi

    frontmatter="$(sed -n "2,$((closing_line - 1))p" "$skill_file")"
    name_count="$(printf '%s\n' "$frontmatter" | grep -c '^name:')"
    description_count="$(printf '%s\n' "$frontmatter" | grep -c '^description:')"
    [ "$name_count" -eq 1 ] || fail "$skill_file must have exactly one name"
    [ "$description_count" -eq 1 ] || fail "$skill_file must have exactly one description"

    name="$(printf '%s\n' "$frontmatter" | sed -n 's/^name:[[:space:]]*//p')"
    description="$(printf '%s\n' "$frontmatter" | sed -n 's/^description:[[:space:]]*//p')"
    [ "$name" = "$skill_dir" ] || fail "$skill_file name does not match directory"
    [ -n "$description" ] || fail "$skill_file description is empty"
    printf '%s\n' "$frontmatter" | grep -q '^description:[[:space:]]*Use when' ||
        fail "$skill_file description must start with Use when"

    frontmatter_keys="$(printf '%s\n' "$frontmatter" | sed -n 's/^\([a-zA-Z0-9_-]*\):.*/\1/p')"
    invalid_keys="$(printf '%s\n' "$frontmatter_keys" | sed '/^name$/d; /^description$/d; /^$/d')"
    [ -z "$invalid_keys" ] || fail "$skill_file has unsupported frontmatter keys: $(printf '%s' "$invalid_keys" | tr '\n' ' ')"

    words="$(wc -w < "$skill_file" | tr -d ' ')"
    [ "$words" -le 500 ] || fail "$skill_file exceeds 500 words: $words"
done < <(find skills -mindepth 2 -maxdepth 2 -name SKILL.md -print | sort)

active_paths=(AGENTS.md CLAUDE.md rules skills agents README.md)

if rg -n '所有请求(一律|强制)|所有仓库任务统一进入|强制进入[[:space:]]*`?superagents|统一入口：所有请求' "${active_paths[@]}" >/dev/null; then
    fail "universal superagents routing remains"
fi

if rg -n '直接执行[[:space:]]*/[[:space:]]*深度交互|所有回答必须分为两个部分|默认采用双段结构' "${active_paths[@]}" >/dev/null; then
    fail "fixed two-section response contract remains"
fi

if rg -n 'code-quality\.md|agents-orchestrator|testing-reality-checker|engineering-software-architect' README.md >/dev/null; then
    fail "README references unavailable repository capabilities"
fi

for spec in \
    '.claude/INSTALL.md claude' \
    '.claude/UPGRADE.md claude' \
    '.codex/INSTALL.md codex' \
    '.codex/UPGRADE.md codex'; do
    read -r doc host <<< "$spec"
    if ! rg -q "scripts/install\\.sh\"?[[:space:]]+$host" "$doc"; then
        fail "$doc does not use the managed $host installer"
    fi
done

while IFS=$'\t' read -r source target; do
    case "$target" in
        http://*|https://*|mailto:*|\#*)
            continue
            ;;
    esac

    target="${target#<}"
    target="${target%>}"
    target="${target%%#*}"
    [ -z "$target" ] && continue

    resolved="$(dirname "$source")/$target"
    [ -e "$resolved" ] || fail "$source has missing local link: $target"
done < <(
    find . -type f -name '*.md' -not -path './.git/*' -print0 |
        xargs -0 perl -ne 'while (/\[[^\]]*\]\((?:<([^>]+)>|([^)[:space:]]+))(?:[[:space:]]+"[^"]*")?\)/g) { my $target = defined $1 ? $1 : $2; print "$ARGV\t$target\n" }'
)

guidance_files=(AGENTS.md CLAUDE.md)
while IFS= read -r path; do guidance_files+=("$path"); done < <(find rules skills agents -type f -name '*.md' -print | sort)

line_count="$(wc -l "${guidance_files[@]}" | tail -1 | awk '{print $1}')"
byte_count="$(wc -c "${guidance_files[@]}" | tail -1 | awk '{print $1}')"
[ "$line_count" -le 1800 ] || fail "guidance exceeds 1800 lines: $line_count"
[ "$byte_count" -le 100000 ] || fail "guidance exceeds 100000 bytes: $byte_count"

if [ "$failures" -ne 0 ]; then
    printf '\n%d verification check(s) failed.\n' "$failures" >&2
    exit 1
fi

printf 'PASS: guidance structure, references, and budgets are valid.\n'
