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
  --method <method>   Install method: symlink or copy.
                      Default: symlink
  --force             Replace existing skill directories or links.
  --dry-run           Print planned actions without writing.
  -h, --help          Show this help.

Examples:
  ./install.sh
  ./install.sh --dest ~/.agents/skills
  ./install.sh --method copy --dest ~/.codex/skills
  ./install.sh --force
USAGE
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$ROOT_DIR/skills"
DEST_DIR="$HOME/.claude/skills"
METHOD="symlink"
FORCE="0"
DRY_RUN="0"

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
if [[ "$DRY_RUN" == "1" ]]; then
  echo "  Mode: dry run"
fi
echo

run mkdir -p "$DEST_DIR"

installed=0
updated=0
skipped=0
conflicts=0

for src in "$SOURCE_DIR"/*; do
  [[ -d "$src" ]] || continue

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
