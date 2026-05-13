---
name: search-chats
description: Search past conversations with Claude Code and Codex CLI. Finds matching excerpts across all sessions with metadata (date, project, agent). Use when looking for a past discussion, decision, or piece of context from any previous session.
argument-hint: "<query> [--agent claude|codex] [--project <name>] [--days <N>]"
allowed-tools: Read, Bash, Glob
---

Search past conversation transcripts across Claude Code and Codex CLI sessions.

## Supported Session Sources

This skill is useful when the local machine has Claude Code or Codex CLI session logs.
If neither directory exists, report the searched paths and stop.

### Claude Code

- Path: `~/.claude/projects/<encoded-project-path>/<session-id>.jsonl`
- Subagent sessions are under `<session-id>/subagents/`; skip them unless specifically requested.
- Content-bearing events usually have `type: "user"` or `type: "assistant"`.
- Skip system/meta content such as `<system_instruction>`, `<system-reminder>`, `<local-command-caveat>`, and attachment-only events.

### Codex CLI

- Path: `~/.codex/sessions/<year>/<month>/<day>/rollout-*.jsonl`
- Metadata is in `type: "session_meta"` records.
- User/assistant turns are usually `type: "response_item"` records.
- Skip developer/system setup text such as `<permissions`, `<collaboration_mode>`, and injected `# AGENTS.md` blocks.

## Arguments

Parse the user's input for:
- **query** (required) — the search terms
- `--agent claude|codex` — restrict to one agent (default: both)
- `--project <name>` — filter to sessions whose project path contains this string
- `--days <N>` — only search sessions modified in the last N days (default: 30)

## Workflow

### 1. Discover Session Files

Use Bash to find JSONL files, filtered by recency:

```bash
# Claude Code sessions
find ~/.claude/projects -name "*.jsonl" -not -path "*/subagents/*" -mtime -${DAYS} -type f

# Codex CLI sessions
find ~/.codex/sessions -name "*.jsonl" -mtime -${DAYS} -type f
```

If `--project` is set, pipe through `grep -i "<project>"` to filter paths.
If `--agent` is set, skip the other source entirely.

### 2. Search Each File

For each session file, use Bash with `grep -i` to check if the query appears before reading the full file.
Only parse files that match.

For matched files, read and extract:
- **Session metadata**: project path, date, agent (claude/codex), session ID
- **Matching turns**: the user or assistant message containing the query
- **Surrounding context**: the immediately preceding and following turns

### 3. Extract Metadata

**Claude Code files:**
- Project: decode directory name (e.g., `-Users-ben-shoemaker-Projects-myapp` → `myapp`)
- Date: `timestamp` field from first user event, or file mtime
- Agent: `claude`

**Codex CLI files:**
- Project: `session_meta.payload.cwd` basename
- Date: from filename timestamp pattern `rollout-YYYY-MM-DDTHH-MM-SS-...`
- Agent: `codex`

### 4. Present Results

Sort results by date (newest first). For each match:

```
## [DATE] PROJECT (AGENT)
Session: SESSION_ID

> **User:** [matching user message excerpt]
> **Assistant:** [matching assistant response excerpt]

---
```

Truncate long messages to ~300 chars with `...` continuation marker.

If no results found:
```
No matches for "QUERY" in the last DAYS days.
Try broadening the search: fewer keywords, more days (--days 90), or drop the project filter.
```

### 5. Summary

End with a one-line count: `Found N matches across M sessions.`

## Error Handling

| Situation | Action |
|-----------|--------|
| No session directories exist | Report the searched paths and stop |
| No matches found | Report "No matching chats found" and suggest broader keywords |
| A session file cannot be read or parsed | Skip it, count it as skipped, and continue |
