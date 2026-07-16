#!/usr/bin/env bash

set -euo pipefail

usage() {
    printf 'Usage: %s <claude|codex>\n' "$0" >&2
}

if [ "$#" -ne 1 ]; then
    usage
    exit 2
fi

host="$1"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

case "$host" in
    claude)
        target="$HOME/.claude"
        entry_files=(AGENTS.md CLAUDE.md)
        ;;
    codex)
        target="$HOME/.codex"
        entry_files=(AGENTS.md)
        ;;
    *)
        usage
        exit 2
        ;;
esac

ownership_file="$target/.dacheng-ai-managed-files"
current_paths=()
previous_paths=()

is_safe_managed_path() {
    case "$1" in
        AGENTS.md|rules/?*|skills/?*|agents/?*) ;;
        CLAUDE.md) [ "$host" = claude ] || return 1 ;;
        *) return 1 ;;
    esac
    case "/$1/" in
        */./*|*/../*|*//*) return 1 ;;
    esac
}

is_current_path() {
    local candidate="$1"
    local current_path
    for current_path in "${current_paths[@]}"; do
        [ "$candidate" = "$current_path" ] && return 0
    done
    return 1
}

while IFS= read -r managed_path; do
    current_paths+=("$managed_path")
done < <(
    {
        printf '%s\n' "${entry_files[@]}"
        cd "$repo_root"
        find rules skills agents -type f -print
    } | LC_ALL=C sort -u
)

if [ -e "$ownership_file" ]; then
    [ -f "$ownership_file" ] || {
        printf 'Managed ownership path is not a file: %s\n' "$ownership_file" >&2
        exit 1
    }
    while IFS= read -r managed_path || [ -n "$managed_path" ]; do
        previous_paths+=("$managed_path")
    done < "$ownership_file"
fi

if [ "${#previous_paths[@]}" -gt 0 ]; then
    for managed_path in "${previous_paths[@]}"; do
        if ! is_safe_managed_path "$managed_path"; then
            printf 'Unsafe managed path in %s: %s\n' "$ownership_file" "$managed_path" >&2
            exit 1
        fi
    done

    for managed_path in "${previous_paths[@]}"; do
        is_current_path "$managed_path" || rm -f -- "$target/$managed_path"
    done
fi

mkdir -p "$target"
for managed_path in "${current_paths[@]}"; do
    is_safe_managed_path "$managed_path" || {
        printf 'Unsafe source-managed path: %s\n' "$managed_path" >&2
        exit 1
    }
    mkdir -p "$(dirname "$target/$managed_path")"
    cp "$repo_root/$managed_path" "$target/$managed_path"
done

ownership_temp="$(mktemp "$target/.dacheng-ai-managed-files.XXXXXX")"
trap 'rm -f "$ownership_temp"' EXIT
printf '%s\n' "${current_paths[@]}" > "$ownership_temp"
mv "$ownership_temp" "$ownership_file"
trap - EXIT

printf 'Installed managed guidance for %s in %s\n' "$host" "$target"
