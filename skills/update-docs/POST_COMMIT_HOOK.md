# Post-Commit Hook for /update-docs

This hook automatically triggers `/update-docs` after each commit to keep documentation in sync.

## Installation

### Option 1: Using /install-hooks (Recommended)

If the project uses the AI Coding Toolkit:

```bash
/install-hooks
```

This installs all configured hooks including the doc-sync hook.

### Option 2: Symlink (Recommended for Toolkit Users)

If the toolkit is installed in your project:

```bash
ln -sf ../../.claude/hooks/post-commit-doc-update.sh .git/hooks/post-commit
chmod +x .git/hooks/post-commit
```

### Option 3: Manual Installation

Copy the full hook script to your project:

```bash
# From your project root
cat > .git/hooks/post-commit << 'EOF'
#!/bin/bash
# Auto-documentation sync hook
# Triggers /update-docs after commits

# Skip if [skip-docs] is in the commit message
COMMIT_MSG=$(git log -1 --pretty=%B)
if echo "$COMMIT_MSG" | grep -q '\[skip-docs\]'; then
    exit 0
fi

# Skip if SKIP_DOC_SYNC environment variable is set
if [ -n "$SKIP_DOC_SYNC" ]; then
    exit 0
fi

# Skip if this is already a docs commit (prevent infinite loops)
# Matches: docs:, docs(scope):, Docs:, DOCS:, etc.
if echo "$COMMIT_MSG" | grep -qiE '^docs(\([^)]*\))?:'; then
    exit 0
fi

# Get repository root
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [ -z "$REPO_ROOT" ]; then
    exit 0
fi

# Create marker directory if needed
mkdir -p "$REPO_ROOT/.claude"

MARKER="$REPO_ROOT/.claude/doc-update-pending.json"
COMMIT_HASH=$(git rev-parse HEAD)
COMMIT_SHORT=$(git rev-parse --short HEAD)
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Escape commit message for JSON (handles quotes, backslashes, newlines)
json_escape() {
    printf '%s' "$1" | sed \
        -e 's/\\/\\\\/g' \
        -e 's/"/\\"/g' \
        -e 's/	/\\t/g' \
        -e ':a' -e 'N' -e '$!ba' -e 's/\n/\\n/g'
}
COMMIT_MSG_ESCAPED=$(json_escape "$(echo "$COMMIT_MSG" | head -1)")

# Get changed files (-m handles merge commits)
CHANGED_FILES=$(git diff-tree --no-commit-id --name-only -r -m HEAD 2>/dev/null || true)
SKILL_COUNT=$(echo "$CHANGED_FILES" | grep -cE "^\.claude/skills/" 2>/dev/null || echo "0")
CONFIG_COUNT=$(echo "$CHANGED_FILES" | grep -cE "(package\.json|\.claude/.*\.json)" 2>/dev/null || echo "0")
TOTAL_FILES=$(echo "$CHANGED_FILES" | grep -c . 2>/dev/null || echo "0")

cat > "$MARKER" << MARKER_EOF
{
  "timestamp": "$TIMESTAMP",
  "commit": "$COMMIT_HASH",
  "commit_short": "$COMMIT_SHORT",
  "message": "$COMMIT_MSG_ESCAPED",
  "trigger": "post-commit",
  "changes": {
    "skills": $SKILL_COUNT,
    "config": $CONFIG_COUNT,
    "total_files": $TOTAL_FILES
  }
}
MARKER_EOF

printf '\n'
printf '\033[0;36m╭─────────────────────────────────────────────────────────────╮\033[0m\n'
printf '\033[0;36m│\033[0m            \033[1;33mDOCUMENTATION SYNC PENDING\033[0m                       \033[0;36m│\033[0m\n'
printf '\033[0;36m╰─────────────────────────────────────────────────────────────╯\033[0m\n'
printf '\n'
printf '\033[0;32mCommit %s\033[0m may require documentation updates.\n' "$COMMIT_SHORT"
printf '\n'
printf '\033[2mClaude will run /update-docs automatically.\033[0m\n'
printf '\033[2mTo skip: add [skip-docs] to commit message\033[0m\n'
printf '\n'

exit 0
EOF

chmod +x .git/hooks/post-commit
```

### Option 4: Add to Existing Hook

If you already have a post-commit hook, append this block. **Important:** Include the skip checks to prevent infinite loops.

```bash
# === Documentation Sync ===
# Skip checks (REQUIRED to prevent infinite loops)
COMMIT_MSG=$(git log -1 --pretty=%B)
if echo "$COMMIT_MSG" | grep -q '\[skip-docs\]'; then
    : # Skip - user requested
elif [ -n "$SKIP_DOC_SYNC" ]; then
    : # Skip - env var set
elif echo "$COMMIT_MSG" | grep -qiE '^docs(\([^)]*\))?:'; then
    : # Skip - this is a docs commit (prevents loops)
else
    # Create marker for Claude
    REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
    if [ -n "$REPO_ROOT" ]; then
        mkdir -p "$REPO_ROOT/.claude"
        MARKER="$REPO_ROOT/.claude/doc-update-pending.json"

        # Escape message for JSON
        MSG_ESCAPED=$(echo "$COMMIT_MSG" | head -1 | sed 's/\\/\\\\/g; s/"/\\"/g')

        cat > "$MARKER" << DOCEOF
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "commit": "$(git rev-parse HEAD)",
  "commit_short": "$(git rev-parse --short HEAD)",
  "message": "$MSG_ESCAPED",
  "trigger": "post-commit"
}
DOCEOF
        printf '\033[1;33mDocumentation sync pending\033[0m - Claude will run /update-docs\n'
    fi
fi
```

## How It Works

1. **Commit happens** → Hook creates `.claude/doc-update-pending.json`
2. **Skip checks** → Exits early for `[skip-docs]`, `docs:` commits, or `SKIP_DOC_SYNC` env
3. **Claude detects marker** → Runs `/update-docs` automatically
4. **Skill analyzes commit** → Determines what docs need updates
5. **Updates applied** → Creates follow-up `docs:` commit
6. **Marker deleted** → Prevents re-triggering

## Marker File Format

```json
{
  "timestamp": "2026-01-27T10:30:00Z",
  "commit": "abc123def456...",
  "commit_short": "abc123d",
  "message": "feat: add user authentication",
  "trigger": "post-commit",
  "changes": {
    "skills": 2,
    "config": 1,
    "total_files": 5
  }
}
```

## Disabling Auto-Sync

### Per-Commit

Add `[skip-docs]` to your commit message:

```bash
git commit -m "chore: minor cleanup [skip-docs]"
```

### Per-Project

Create `.claude/doc-sync-config.json`:

```json
{
  "enabled": false
}
```

### Temporarily

```bash
SKIP_DOC_SYNC=1 git commit -m "your message"
```

## Troubleshooting

### Hook not running

1. Check hook is executable: `ls -la .git/hooks/post-commit`
2. Verify shebang: First line should be `#!/bin/bash`
3. Check hook path: Git hooks must be in `.git/hooks/`

### Claude not detecting marker

1. Check marker exists: `cat .claude/doc-update-pending.json`
2. Check `.gitignore`: Marker file should NOT be gitignored
3. Run `/update-docs` manually to process pending marker

### Documentation not updating

1. Run manually: `/update-docs` to see detailed output
2. Check if changes warrant updates (minor changes may be skipped)
3. Review `.claude/doc-sync.log` for history

### Infinite loop (docs commit triggers docs commit)

This should not happen if skip checks are in place. Verify your hook includes:
```bash
if echo "$COMMIT_MSG" | grep -qiE '^docs(\([^)]*\))?:'; then
    exit 0
fi
```

## Integration with AGENTS.md

Add to your project's AGENTS.md:

```markdown
## Post-Commit Hooks

This project uses automatic documentation sync. After commits, the
`/update-docs` skill runs to keep README, CHANGELOG, and docs/ current.

To skip for a commit: add `[skip-docs]` to the commit message.
```
