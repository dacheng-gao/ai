#!/usr/bin/env bash
#
# install.sh - Copy skills and rules to AI tool directories
#
# Usage:
#   ./scripts/install.sh [targets...]
#
# Options:
#   -n, --dry-run    Show what would be copied without copying
#   -v, --verbose    Verbose output
#   -h, --help       Show this help message
#
# Targets:
#   claude           Copy to ~/.claude/skills/
#   codex            Copy to ~/.codex/skills/
#   antigravity      Copy to ~/.gemini/antigravity/global_skills/
#   opencode         Copy to ~/.config/opencode/ (rules and skills)
#   all              Copy to all targets (default)
#
# Examples:
#   ./scripts/install.sh              # Install to all targets
#   ./scripts/install.sh claude       # Install to claude only
#   ./scripts/install.sh codex claude # Install to codex and claude
#   ./scripts/install.sh opencode     # Install to opencode (rules and skills)
#   ./scripts/install.sh -n all       # Dry run for all targets

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
SOURCE_DIR="$REPO_DIR/skills"
RULES_DIR="$REPO_DIR/rules"

DRY_RUN=false
VERBOSE=false

get_target_dir() {
    local target="$1"
    case "$target" in
        claude)      echo "$HOME/.claude/skills" ;;
        codex)       echo "$HOME/.codex/skills" ;;
        antigravity) echo "$HOME/.gemini/antigravity/global_skills" ;;
        opencode)    echo "$HOME/.config/opencode" ;;
    esac
}

copy_skills() {
    local target_name="$1"
    local target_dir="$2"

    if [[ "$DRY_RUN" == true ]]; then
        echo "[DRY-RUN] Would copy skills to $target_name: $target_dir"
        return 0
    fi

    if [[ ! -d "$target_dir" ]]; then
        mkdir -p "$target_dir"
    fi

    local count=0
    for skill_dir in "$SOURCE_DIR"/*/; do
        if [[ -d "$skill_dir" ]]; then
            local skill_name
            skill_name=$(basename "$skill_dir")
            local target_skill_dir="$target_dir/$skill_name"

            if [[ "$VERBOSE" == true ]]; then
                echo "Copying $skill_name to $target_skill_dir/"
            fi

            if command -v rsync &>/dev/null; then
                rsync -a --delete "${skill_dir%/}/" "$target_skill_dir/"
            else
                rm -rf "${target_skill_dir:?}"
                cp -R "${skill_dir%/}" "$target_dir/"
            fi

            ((count++))
        fi
    done

    echo "✓ Installed $count skills to $target_name"
}

copy_rules() {
    local target_name="$1"
    local target_dir="$2"

    if [[ "$DRY_RUN" == true ]]; then
        echo "[DRY-RUN] Would copy rules to $target_name: $target_dir"
        return 0
    fi

    if [[ ! -d "$target_dir" ]]; then
        mkdir -p "$target_dir"
    fi

    local count=0
    for rule_file in "$RULES_DIR"/*.md; do
        if [[ -f "$rule_file" ]]; then
            local rule_name
            rule_name=$(basename "$rule_file")
            local target_rule_file="$target_dir/$rule_name"

            if [[ "$VERBOSE" == true ]]; then
                echo "Copying $rule_name to $target_dir/"
            fi

            cp "$rule_file" "$target_rule_file"

            ((count++))
        fi
    done

    echo "✓ Installed $count rules to $target_name"
}

main() {
    local selected_targets=()
    local all_targets=(claude codex antigravity opencode)

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -n|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -h|--help)
                head -30 "$0" | grep -E '^#' | sed 's/^# *//' | tail -n +2
                exit 0
                ;;
            all)
                selected_targets=("${all_targets[@]}")
                shift
                ;;
            claude|codex|antigravity|opencode)
                selected_targets+=("$1")
                shift
                ;;
            *)
                echo "Unknown option or target: $1" >&2
                exit 1
                ;;
        esac
    done

    if [[ ${#selected_targets[@]} -eq 0 ]]; then
        selected_targets=("${all_targets[@]}")
    fi

    if [[ ! -d "$SOURCE_DIR" ]]; then
        echo "Source directory not found: $SOURCE_DIR" >&2
        exit 1
    fi

    local skill_count
    skill_count=$(find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
    echo "Found $skill_count skills in $SOURCE_DIR"

    local rule_count
    rule_count=$(find "$RULES_DIR" -maxdepth 1 -name '*.md' | wc -l | tr -d ' ')
    echo "Found $rule_count rules in $RULES_DIR"

    if [[ "$DRY_RUN" == true ]]; then
        echo "Dry run mode - no files will be copied"
    fi

    for target in "${selected_targets[@]}"; do
        local target_dir
        target_dir=$(get_target_dir "$target")

        if [[ "$target" == "opencode" ]]; then
            copy_rules "$target" "$target_dir/rules"
            copy_skills "$target" "$target_dir/skills"
        else
            copy_skills "$target" "$target_dir"
        fi
    done

    echo "Done!"
}

main "$@"
