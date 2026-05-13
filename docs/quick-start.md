# Quick Start

This walkthrough shows the skills in the rough order they show up during
feature development.

## 1. Install The Skills

From this repo:

```bash
./install.sh
```

For a different agent directory:

```bash
./install.sh --dest ~/.agents/skills
```

Restart your agent after installing.

## 2. Use Codex As A Second Model

During feature work, use Codex for planning, review, and scoped implementation:

```text
/codex-consult FEATURE_SPEC.md
/codex-review
/codex-implement "Add the missing empty state using the existing component patterns"
```

Expected result:

- `codex-consult` gives a second opinion on docs, plans, and specs.
- `codex-review` checks the current diff or branch.
- `codex-implement` delegates a bounded implementation task to Codex CLI.

## 3. Capture Side Work As It Appears

In a target project, ask your agent:

```text
/capture-work The dashboard crashes when a saved filter references a deleted field
```

Expected result:

- The skill classifies the item as a bug.
- It creates or updates `BUGS.md`.
- If details are missing, it records `Needs reproduction` or `Not specified`
  instead of inventing facts.

Capture a next step:

```text
/capture-work Add an empty state to the reports page
```

Expected result:

- The skill classifies the item as a next step unless it is feature-sized.
- It creates or updates `NEXT_STEPS.md`.
- Large feature ideas are routed toward a feature workflow instead of being
  squeezed into a TODO list.

## 4. Define Flow Verification

Ask:

```text
/discover-flow-verification "A user can save a report filter and see it applied after reload"
```

Expected result:

- The skill identifies the exact flow claim.
- It recommends a repeatable harness shape.
- It names the command, browser/API actions, assertions, evidence, and teardown
  needed for agent-verifiable proof.

## 5. Triage Active Work

Ask:

```text
/triage
```

Expected result:

- Bugs and next steps are ranked together.
- Vague items are marked as needing clarification.
- Completed or obsolete work can be moved to `archive/work-items/YYYY-MM.md`.
- The skill reports recommended next work but asks before implementation.

## 6. Finish The Feature

Ask:

```text
/update-docs --working-tree
/capture-session
```

Expected result:

- `update-docs` brings README, AGENTS.md, CHANGELOG, and docs up to date.
- `capture-session` preserves decisions, context, action items, and issues in
  `LEARNINGS.md`.

## 7. Use Milestone Skills

At larger milestones, ask:

```text
/ui-ux audit src/components
/innovate
/data-flow-audit
/search-chats "pricing CTA"
/work-status
```

Expected result:

- `ui-ux` finds interface and design-system issues.
- `innovate` proposes one high-leverage product improvement.
- `data-flow-audit` finds duplicated business rules and split data sources.
- `search-chats` recovers prior decisions from local agent sessions.
- `work-status` summarizes the next likely work across active tracking files.

## Optional Agent Instruction Snippet

Add this to `AGENTS.md` if you want all agents to use the same work-tracking
surfaces even when they do not explicitly invoke these skills:

```markdown
## Work Tracking

Use `BUGS.md` for active bugs, `NEXT_STEPS.md` for imminent small non-bug work,
and `DEFERRED.md` for ideas not planned soon. Use `features/<name>/` for
feature-sized work. Completed, removed, or obsolete lightweight items move to
`archive/work-items/YYYY-MM.md`.
```
