---
name: search-chats
description: Recover prior discussions, decisions, and matching excerpts from Codex and Claude Code conversations. Use native Codex chat tools when available, with local transcript search for broad content searches, cross-client history, or CLI environments.
argument-hint: "<query> [--agent claude|codex] [--project <name>] [--days <N>]"
---

# Search Chats

Recover relevant conversation evidence using the capabilities available in the
current client. Keep retrieval read-only; continuing or messaging a chat is a
separate action that requires the user's request.

## Scope

Accept a natural-language request or a query with these optional filters:

- `--agent claude|codex`: restrict the source; otherwise consider both.
- `--project <name>`: match the conversation's project path or project context.
- `--days <N>`: restrict by conversation/message timestamps. When no period is
  given, start with the last 30 days; follow explicit requests for older history.

Treat quoted phrases as literal text. For conceptual requests, use related
terms and verify the surrounding discussion before reporting a decision.

## Choose the Retrieval Route

Prefer native Codex tools for identifiable chats and project context. Use local
transcripts for Claude history, broad phrase searches, exhaustive requests, or
when native tools are unavailable or cannot recover the needed evidence.

```text
Retrieval Progress:
- [ ] Establish sources, project, and time range
- [ ] Retrieve candidate chats through the appropriate route
- [ ] Verify matching turns and context
- [ ] Report evidence and coverage limits
```

### Native Codex Tools

Discover the tools exposed by the current runtime and read their schemas;
availability and supported filters vary by client and version. In Codex desktop:

- `list_threads` supplies pinned and recent chats with titles, project context,
  and retrieval summaries. It is candidate discovery, not a full-text query.
- `list_archived_threads` retrieves archived chats; follow returned pagination
  cursors when the requested history requires more pages.
- `read_thread` retrieves a selected chat's turn summaries and optional outputs.
  Use the returned thread ID and host ID where supported, and page backward
  with returned cursors to reach the relevant period. Request outputs only when
  needed to substantiate the answer.

Select Codex-backed entries and filter candidates using the requested project
and period, then verify the discussion through `read_thread`. Use returned
titles verbatim. Summaries help locate evidence but are not exact quotations or
proof of exhaustive coverage.

If a native conversation-search tool is available, use its documented query and
scope parameters, then retrieve matching turns. Do not invent search arguments
for listing tools. The Codex app also has user-facing search across conversation
content and Git branch names; that UI capability does not imply an equivalent
agent tool is exposed. Use available tools or local logs to complete retrieval
without requiring the user to search manually.

If listings or truncated reads cannot resolve a broad content search, switch to
accessible local transcripts. Remote chat access does not imply that those
transcripts exist on the current machine.

### Local Transcript Search

Inspect existing source directories within the granted source access:

| Source | Location | Metadata and content |
|--------|----------|----------------------|
| Claude Code | `~/.claude/projects/<encoded-project-path>/` | User/assistant events; project from event metadata when available, otherwise the encoded directory; date from event timestamps. Skip `subagents/` unless requested. |
| Codex | `sessions/` and `archived_sessions/` under `CODEX_HOME`, or `~/.codex` when unset | `session_meta.payload` supplies cwd, session ID, and timestamp; `response_item` message records supply user/assistant content. |

Discover `*.jsonl` and compressed variants such as `*.jsonl.zst`; Codex archives
need not use the active sessions' date-directory layout. Use `rg --files` for
discovery and literal, case-insensitive `rg -F -i` to shortlist uncompressed
files. Stream compressed files through an available matching decompressor
(for example, `zstd -dc` for `.zst`) or library, then search/parse the decoded
JSONL. If decompression is unavailable, report those files as unsearched.
For queries affected by JSON escaping or split text blocks, search decoded
message text directly rather than relying on a raw-file shortlist.

Parse shortlisted files as JSON records and match only user/assistant message
text. Exclude system/developer setup, injected instructions, tool output, and
attachment-only events unless the user requests those sources. Preserve real
user text around injected blocks. A raw file match is only a candidate: queries
can occur in metadata or setup text without appearing in a conversation turn.

For Codex, apply the project filter to `session_meta.payload.cwd`, not the
rollout filename. Prefer event timestamps for time filters; file modification
time is only a discovery hint, since resumed or archived chats can have older
messages. Read the immediately surrounding user/assistant turns to distinguish
proposals, corrections, and accepted decisions. Deduplicate by session ID and
turn identity when native and local retrieval overlap.

## Results and Coverage

Sort matches newest first. Include the date, project, client, native chat title
when available, and thread/session ID. Give a short matching excerpt with enough
context to answer the request, plus a source locator: a native thread ID and turn
identifier when returned, or a transcript path and record/line location. Label
summaries as summaries; quote only text actually retrieved. Keep excerpts brief
unless more context is necessary.

Finish with the match/session count and the sources and time range searched.
Disclose truncation, inaccessible hosts, skipped files, or incomplete listing
coverage. A missing source or unsupported parser is a coverage gap, not evidence
that no matching chats exist. On malformed records, skip and count them while
continuing through readable records. If nothing matches, state the searched
scope and suggest broader terms or an older period. If no source is accessible,
report the unavailable tools/paths and stop.
