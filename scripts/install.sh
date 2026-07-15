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

mkdir -p "$target/rules" "$target/skills" "$target/agents"

while IFS= read -r path; do
    [ -n "$path" ] || continue
    case "$path" in
        /*|..|../*|*/..|*/../*)
            printf 'Unsafe obsolete path: %s\n' "$path" >&2
            exit 1
            ;;
    esac
    rm -f -- "$target/$path"
done < "$repo_root/scripts/obsolete-paths.txt"

for path in \
    "$target/skills/develop-feature/references" \
    "$target/skills/fix-bug/references" \
    "$target/skills/review-code/references" \
    "$target/skills/superagents/references" \
    "$target/skills/superagents/templates"; do
    rmdir "$path" 2>/dev/null || true
done

for path in "${entry_files[@]}"; do
    cp "$repo_root/$path" "$target/$path"
done

cp -R "$repo_root/rules/." "$target/rules/"
cp -R "$repo_root/skills/." "$target/skills/"
cp -R "$repo_root/agents/." "$target/agents/"

printf 'Installed managed guidance for %s in %s\n' "$host" "$target"
