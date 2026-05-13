---
name: work-status
description: Summarize all possible work across features, bugs, next steps, deferred items, and archived/completed work. Use when the user asks what can be worked on next or asks for status across work tracking files.
allowed-tools: Read, Glob, Grep
---

# Work Status

Summarize the repository's work options and their status across all tracking
surfaces.

## Read Order

1. `plans/PLAN_STATUS.md`
2. `features/*/FEATURE_SPEC.md`, `features/*/EXECUTION_PLAN.md`, and
   `features/*/.claude/phase-state.json` when present
3. `BUGS.md`
4. `NEXT_STEPS.md`
5. `DEFERRED.md`
6. `archive/work-items/*.md` for recent completed/removed history

Do not treat archived, superseded, rejected, abandoned, completed, or
research-only features as active unless the user explicitly revives them.

## Classification

Report work in these groups:

- Active/planned features
- Open bugs
- Ranked next steps
- Deferred ideas
- Recently archived/completed items

For features, prefer concrete execution evidence over stale manifest text:
`.claude/phase-state.json` and verification evidence are stronger completion
signals than `plans/PLAN_STATUS.md` if they disagree.

## Output

Keep the report compact:

```markdown
# Work Status

## Best Candidates
1. {item} — {why it is likely next}

## Features
- {name}: {status/stage/path}

## Bugs
- {count open}; top: {item}

## Next Steps
- {count open}; top: {item}

## Deferred
- {count deferred}; not planned for imminent work

## Recent Archive
- {latest completed/removed items if any}

## Notes
- {manifest drift, missing files, or unclear items}
```

If the user asks what to do next, include a recommendation. If they only ask for
status, avoid over-prioritizing.
