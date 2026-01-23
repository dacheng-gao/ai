#!/usr/bin/env bash
#
# install-skills.sh - Fast install (copy) skills to codex / claude / antigravity
#
# Usage:
#   ./scripts/install-skills.sh [options] [targets...]
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
#   all              Copy to all targets (default)
#
# Examples:
#   ./scripts/install-skills.sh              # Install to all targets
#   ./scripts/install-skills.sh claude       # Install to claude only
#   ./scripts/install-skills.sh codex claude # Install to codex and claude
#   ./scripts/install-skills.sh -n all       # Dry run for all targets

set -euo pipefail

# Get script directory (source of skills)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
SOURCE_DIR="$REPO_DIR/skills"

# Options
DRY_RUN=false
VERBOSE=false

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_verbose() {
    if [[ "$VERBOSE" == true ]]; then
        echo -e "${BLUE}[VERBOSE]${NC} $1"
    fi
}

show_help() {
    head -30 "$0" | grep -E '^#' | sed 's/^# *//' | tail -n +2
}

get_target_dir() {
    local target="$1"
    case "$target" in
        claude)      echo "$HOME/.claude/skills" ;;
        codex)       echo "$HOME/.codex/skills" ;;
        antigravity) echo "$HOME/.gemini/antigravity/global_skills" ;;
    esac
}

copy_skills() {
    local target_name="$1"
    local target_dir="$2"

    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY-RUN] Would copy skills to $target_name: $target_dir"
        return 0
    fi

    # Create target directory if not exists
    if [[ ! -d "$target_dir" ]]; then
        log_verbose "Creating directory: $target_dir"
        mkdir -p "$target_dir"
    fi

    # Copy each skill directory
    local count=0
    for skill_dir in "$SOURCE_DIR"/*/; do
        if [[ -d "$skill_dir" ]]; then
            local skill_name
            skill_name=$(basename "$skill_dir")
            local target_skill_dir="$target_dir/$skill_name"

            log_verbose "Copying $skill_name to $target_skill_dir/"

            # Use rsync for efficient copy (preserves timestamps, handles updates)
            if command -v rsync &>/dev/null; then
                rsync -a --delete "${skill_dir%/}/" "$target_skill_dir/"
            else
                # Fallback to cp
                rm -rf "${target_skill_dir:?}"
                cp -R "${skill_dir%/}" "$target_dir/"
            fi

            ((count++))
        fi
    done

    log_success "Installed $count skills to $target_name"
}

main() {
    local selected_targets=()
    local all_targets=(claude codex antigravity)

    # Parse arguments
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
                show_help
                exit 0
                ;;
            all)
                selected_targets=("${all_targets[@]}")
                shift
                ;;
            claude|codex|antigravity)
                selected_targets+=("$1")
                shift
                ;;
            *)
                log_error "Unknown option or target: $1"
                show_help
                exit 1
                ;;
        esac
    done

    # Default to all if no targets specified
    if [[ ${#selected_targets[@]} -eq 0 ]]; then
        selected_targets=("${all_targets[@]}")
    fi

    # Verify source directory exists
    if [[ ! -d "$SOURCE_DIR" ]]; then
        log_error "Source directory not found: $SOURCE_DIR"
        exit 1
    fi

    # Count skills
    local skill_count
    skill_count=$(find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
    log_info "Found $skill_count skills in $SOURCE_DIR"

    if [[ "$DRY_RUN" == true ]]; then
        log_warn "Dry run mode - no files will be copied"
    fi

    # Copy to selected targets
    for target in "${selected_targets[@]}"; do
        local target_dir
        target_dir=$(get_target_dir "$target")
        copy_skills "$target" "$target_dir"
    done

    log_success "Done!"
}

main "$@"
