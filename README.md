# Ben's Indispensable Skills

A curated set of AI coding-agent skills I use constantly while building apps:
cross-model Codex workflows, lightweight work tracking, flow verification,
session capture, audits, and product/UX strategy.

These skills are copied from the
[AI Coding Toolkit](https://github.com/benjaminshoemaker/ai_coding_project_base).
That repo is where I spec out larger workflow systems. This repo is the smaller
shareable bundle of the skills I actually reach for while doing day-to-day work.

## Skill Tiers

### Daily Work Tracking

These keep non-primary work from getting lost while I am focused on a feature.

- `capture-work` — Capture new bugs, next steps, deferred ideas, or
  feature-sized follow-ups.
- `triage` — Rank active bugs and next steps, clean up work tracking files, and
  identify what should be worked on next.
- `work-status` — Summarize feature work, bugs, next steps, deferred ideas, and
  recent archive history.

### Daily Feature Support

These show up in most feature work, especially as a feature gets close to done.

- `discover-flow-verification` — Design a repeatable verification harness for a
  specific user or integration flow.
- `update-docs` — Update README, AGENTS.md, CHANGELOG, and docs based on commits
  or working-tree changes.
- `capture-session` — Extract decisions, action items, new context, bugs, and
  deferred investigations from a substantive session.

### Conditional: Claude Code Cross-Model Workflow

These are indispensable when I am working in Claude Code: I use them on an
hourly or daily basis to bring Codex in as a second model. When I am using Codex
directly, I do not use these skills.

- `codex-consult` — Get Codex feedback on docs, specs, plans, and other
  non-code-diff content.
- `codex-review` — Ask Codex to review the current code diff or branch.
- `codex-implement` — Delegate a scoped implementation task to Codex CLI with
  context scoping and verification.

### Weekly / Milestone Strategy

These are less frequent than the daily skills, but very high value for aligning
the product, finding common issues, and surfacing ideas I had not considered.

- `search-chats` — Search local Claude Code and Codex CLI session transcripts.
- `data-flow-audit` — Detect split data sources, duplicated business rules, and
  cross-layer formula drift.
- `ui-ux` — Audit or design UI/UX using product context, code review, and design
  system guidance.
- `innovate` — Identify one high-leverage product or workflow improvement.

### Skill Quality

This is mostly for maintaining skill repos and prompt systems.

- `audit-skills` — Audit skills, commands, and prompt templates for common
  quality issues.

## Feature Development Lifecycle

These skills fit into the way I usually build features:

1. Work on a feature in a target app. Larger planning/spec workflows live in the
   [AI Coding Toolkit](https://github.com/benjaminshoemaker/ai_coding_project_base).
2. Use `codex-consult`, `codex-review`, and `codex-implement` throughout the
   work to get second-model planning, review, and implementation help.
3. Use `capture-work` whenever new bugs, next steps, or deferred ideas come up
   that are not the primary feature workflow.
4. Use `triage` and `work-status` to decide what should happen next when the
   side queue starts to matter.
5. Use `discover-flow-verification` for most meaningful features to define how
   an agent can verify the actual user or integration flow.
6. As the feature gets close to finished, use `update-docs` and
   `capture-session` so docs and durable context catch up with the work.
7. At larger milestones, use `ui-ux`, `innovate`, `data-flow-audit`, and
   `search-chats` to find design issues, product opportunities, repeated
   patterns, and architectural drift.

## Installation

Clone the repo:

```bash
git clone https://github.com/benjaminshoemaker/bens_indispensable_skills.git
cd bens_indispensable_skills
```

Then run the installer:

```bash
./install.sh
```

By default, this symlinks skills into `~/.claude/skills`.

Common destinations:

- Claude Code: `~/.claude/skills/`
- Codex / agent runtimes using the agents layout: `~/.agents/skills/`
- Codex setups that read directly from Codex home: `~/.codex/skills/`

Install somewhere else:

```bash
./install.sh --dest ~/.agents/skills
```

Install by copying instead of symlinking:

```bash
./install.sh --method copy
```

Restart your agent after installing so it can reload available skills.

See [Compatibility](docs/compatibility.md) for per-skill requirements and common
agent skill directories.

## Quick Start

See [Quick Start](docs/quick-start.md) for a short walkthrough of:

1. Installing the bundle
2. Using Codex as a second model
3. Capturing side work
4. Defining flow verification
5. Finishing with docs and session capture
6. Running milestone strategy skills

## Optional Project Conventions

The work-tracking skills work without project setup, but they are most effective
when a repo consistently uses these files:

- `BUGS.md` for active bugs and regressions
- `NEXT_STEPS.md` for imminent small non-bug work
- `DEFERRED.md` for ideas not planned soon
- `archive/work-items/YYYY-MM.md` for completed, removed, or obsolete work items
- `features/<name>/` for feature-sized work

For durable session memory, add a note to your agent instructions telling future
agents to read `LEARNINGS.md` during orientation. In Claude Code projects, this
can be as simple as adding `@LEARNINGS.md` to `CLAUDE.md`.

## Repository Contents

- [install.sh](install.sh) — Install by symlink or copy.
- [Compatibility](docs/compatibility.md) — Per-skill requirements and caveats.
- [Quick Start](docs/quick-start.md) — A first workflow to try after installing.
- [LICENSE](LICENSE) — MIT license.

## Future Improvements

The main remaining packaging improvement is a changelog or release notes section
summarizing synced toolkit updates.

## Sync Metadata

`toolkit-version.json` records the source toolkit commit and per-skill hashes
from the last sync.
