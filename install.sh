#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Install Ben's Indispensable Skills into an agent skills directory.

Usage:
  ./install.sh [options]

Options:
  --dest <path>       Destination skills directory.
                      Default: ~/.claude/skills
  --method <method>   Install method: copy or symlink.
                      Default: copy
  --force             Replace existing skill directories or links.
  --dry-run           Print planned actions without writing.
  --skill <name>      Install one skill. Repeat to select multiple skills.
  --all               Install every available skill.
  --list              List available skills and exit.
  -h, --help          Show this help.

Examples:
  ./install.sh --all
  ./install.sh --dest ~/.agents/skills
  ./install.sh --method copy --dest ~/.codex/skills
  ./install.sh --skill project-research --skill design-directions
  ./install.sh --force --skill project-research

Choose at least one --skill or use --all explicitly.
USAGE
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$ROOT_DIR/skills"
DEST_DIR="$HOME/.claude/skills"
METHOD="copy"
FORCE="0"
DRY_RUN="0"
LIST_ONLY="0"
ALL_SKILLS="0"
SELECTED_SKILLS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dest)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --dest" >&2
        exit 2
      fi
      DEST_DIR="${2/#\~/$HOME}"
      shift 2
      ;;
    --method)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --method" >&2
        exit 2
      fi
      METHOD="$2"
      shift 2
      ;;
    --force)
      FORCE="1"
      shift
      ;;
    --dry-run)
      DRY_RUN="1"
      shift
      ;;
    --skill)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --skill" >&2
        exit 2
      fi
      SELECTED_SKILLS+=("$2")
      shift 2
      ;;
    --all)
      ALL_SKILLS="1"
      shift
      ;;
    --list)
      LIST_ONLY="1"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ "$METHOD" != "symlink" && "$METHOD" != "copy" ]]; then
  echo "Invalid --method: $METHOD (expected symlink or copy)" >&2
  exit 2
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Source skills directory not found: $SOURCE_DIR" >&2
  exit 1
fi

list_skills() {
  local src
  for src in "$SOURCE_DIR"/*; do
    [[ -d "$src" && -f "$src/SKILL.md" ]] || continue
    basename "$src"
  done
}

if [[ "$LIST_ONLY" == "1" ]]; then
  list_skills
  exit 0
fi

if [[ "$ALL_SKILLS" == "1" && ${#SELECTED_SKILLS[@]} -gt 0 ]]; then
  echo "--all cannot be combined with --skill" >&2
  exit 2
fi

if [[ "$ALL_SKILLS" != "1" && ${#SELECTED_SKILLS[@]} -eq 0 ]]; then
  echo "Select at least one skill or use --all." >&2
  echo "Run ./install.sh --list to see available skills." >&2
  exit 2
fi

SOURCES=()
if [[ "$ALL_SKILLS" == "1" ]]; then
  for src in "$SOURCE_DIR"/*; do
    [[ -d "$src" && -f "$src/SKILL.md" ]] || continue
    SOURCES+=("$src")
  done
else
  for name in "${SELECTED_SKILLS[@]}"; do
    src="$SOURCE_DIR/$name"
    if [[ "$name" == */* || ! -d "$src" || ! -f "$src/SKILL.md" ]]; then
      echo "Unknown skill: $name" >&2
      echo "Run ./install.sh --list to see available skills." >&2
      exit 2
    fi

    already_selected="0"
    if [[ ${#SOURCES[@]} -gt 0 ]]; then
      for existing in "${SOURCES[@]}"; do
        if [[ "$existing" == "$src" ]]; then
          already_selected="1"
          break
        fi
      done
    fi
    if [[ "$already_selected" == "0" ]]; then
      SOURCES+=("$src")
    fi
  done
fi

run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '  '
    printf '%q ' "$@"
    printf '\n'
    return 0
  fi
  "$@"
}

echo "Installing skills"
echo "  Source: $SOURCE_DIR"
echo "  Destination: $DEST_DIR"
echo "  Method: $METHOD"
if [[ "$ALL_SKILLS" == "1" ]]; then
  echo "  Selection: all skills"
else
  echo "  Selection: ${SELECTED_SKILLS[*]}"
fi
if [[ "$DRY_RUN" == "1" ]]; then
  echo "  Mode: dry run"
fi
echo

run mkdir -p "$DEST_DIR"

installed=0
updated=0
skipped=0
conflicts=0

for src in "${SOURCES[@]}"; do
  name="$(basename "$src")"
  dest="$DEST_DIR/$name"

  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ "$FORCE" != "1" ]]; then
      echo "[SKIP] $name already exists. Use --force to replace."
      skipped=$((skipped + 1))
      continue
    fi

    case "$dest" in
      "$DEST_DIR"/*)
        run rm -rf "$dest"
        updated=$((updated + 1))
        ;;
      *)
        echo "[CONFLICT] Refusing to remove suspicious path: $dest" >&2
        conflicts=$((conflicts + 1))
        continue
        ;;
    esac
  else
    installed=$((installed + 1))
  fi

  if [[ "$METHOD" == "symlink" ]]; then
    run ln -s "$src" "$dest"
  else
    run cp -R "$src" "$dest"
  fi
  echo "[OK] $name"
done

echo
echo "Install summary"
echo "  Installed: $installed"
echo "  Updated:   $updated"
echo "  Skipped:   $skipped"
echo "  Conflicts: $conflicts"
echo
echo "Restart your agent so it reloads available skills."

if [[ "$conflicts" -gt 0 ]]; then
  exit 1
fi
