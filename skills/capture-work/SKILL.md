---
name: capture-work
description: Capture a lightweight work item into BUGS.md, NEXT_STEPS.md, DEFERRED.md, or recommend the feature workflow. Use when a bug, fix, small follow-up, next step, deferred idea, or possible feature comes up during development.
argument-hint: ["work item"]
allowed-tools: Read, Write, Edit, Glob, AskUserQuestion
---

# Capture Work

Capture one lightweight work item without the old generic TODO workflow.

## Work Lanes

| Lane | File/location | Use when |
|------|---------------|----------|
| Feature | `features/<name>/` | Meaningful new product capability that needs spec/planning |
| Bug | `BUGS.md` | Broken behavior, regression, crash, incorrect result, or fix |
| Next step | `NEXT_STEPS.md` | Small non-bug work the user expects to do soon |
| Deferred | `DEFERRED.md` | Feature idea or next-step idea not planned indefinitely |

Do not defer bugs. If a bug will not be fixed soon, keep it in `BUGS.md` with a
note about priority or blocker.

## Process

1. Get the item text from `$ARGUMENTS`; if missing, ask for a concise item.
2. Classify using the work lanes above.
3. Ask only when classification is genuinely ambiguous.
4. Create the target file if missing.
5. Append a lightweight entry.

## Formats

### BUGS.md

```markdown
# Bugs

## Open

### {Title}

- Severity: P0|P1|P2
- Repro: {short reproduction steps, or "Needs reproduction"}
- Expected: {expected behavior}
- Actual: {actual behavior}
- Notes: {optional context}
```

If the user did not provide repro/expected/actual, infer only from clear
context. Use `Needs reproduction` or `Not specified` instead of inventing.

### NEXT_STEPS.md

```markdown
# Next Steps

## Ranked

1. **{Title}** — {brief context}
```

Append at the end by default. `/triage` owns ranking.

### DEFERRED.md

```markdown
# Deferred

## Ideas

- **{Title}** — {why deferred or context}
```

Deferred means the user is not planning to work on it indefinitely. Imminent
work belongs in `NEXT_STEPS.md`.

## Feature-Sized Work

If the item is too large for `NEXT_STEPS.md`, do not create a feature directory
automatically. Recommend `/feature-spec <name>` and include a suggested feature
slug.

## Completion

Report the lane and file changed. If no file was changed because the item should
be a feature, report the recommended command.
