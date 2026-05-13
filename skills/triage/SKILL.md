---
name: triage
description: Review BUGS.md and NEXT_STEPS.md together, rank what to work on next, and update lightweight work tracking files when useful. Use when deciding between bugs, fixes, and small next-step work.
allowed-tools: Read, Write, Edit, Glob, Grep, AskUserQuestion
---

# Triage

Triage active lightweight work across `BUGS.md` and `NEXT_STEPS.md`.

This replaces the old `/list-todos` and `/run-todos` flow. It may edit files
when needed, but ask before starting implementation. Features remain in
`features/<name>/` and deferred indefinite ideas remain in `DEFERRED.md`.

## Inputs

Read, if present:

1. `BUGS.md`
2. `NEXT_STEPS.md`
3. `DEFERRED.md` for context only
4. `plans/PLAN_STATUS.md` and `features/*/FEATURE_SPEC.md` only when needed to
   understand feature-sized work
5. `VISION.md`, `PRODUCT_SPEC.md`, or `plans/greenfield/PRODUCT_SPEC.md` for
   project alignment when available

If both `BUGS.md` and `NEXT_STEPS.md` are missing or empty, say there is no
active lightweight work and suggest `/capture-work`.

## Ranking

Rank open bugs and next steps together using:

- User impact and severity
- Confidence that the item is real and understood
- Immediacy: bugs and blocking work usually outrank polish
- Project alignment
- Effort and dependency risk
- Whether an item is actually feature-sized

Do not pretend vague items are ready. If a bug lacks reproduction steps, mark it
as needing reproduction unless the current repo context makes it obvious.

## File Updates

When useful, update files directly:

- Reorder `NEXT_STEPS.md` ranked items.
- Normalize `BUGS.md` entries into `Severity`, `Repro`, `Expected`, `Actual`,
  and optional `Notes`.
- Move indefinite ideas from `NEXT_STEPS.md` to `DEFERRED.md`.
- Recommend `/feature-spec <name>` for feature-sized items instead of keeping
  them as next steps.
- Archive completed, removed, or obsolete items immediately.

## Archive

Use `archive/work-items/YYYY-MM.md`.

Archive entries under one of these headings:

```markdown
# Work Items Archive - YYYY-MM

## Bugs

## Next Steps

## Deferred
```

When archiving, move the full item text out of the active file and add a short
status note such as `Completed`, `Removed`, `Superseded`, or `Moved to feature`.

## Output

Return:

```markdown
# Triage

## Recommended Next Work
1. {Bug or next step} — {reason}

## Active Bugs
- {count and highest-priority notes}

## Active Next Steps
- {count and highest-priority notes}

## Changes Made
- {files edited, or "None"}

## Needs Clarification
- {items that need human input before implementation}
```

Before implementing any item, ask which item to start. `/triage` decides and
organizes; execution begins only after explicit user direction.
