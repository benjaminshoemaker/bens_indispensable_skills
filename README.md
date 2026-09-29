# Ben's Indispensable Skills

A curated set of AI coding-agent skills I use while researching and building
apps: project discovery, cross-model Codex workflows, flow verification,
audits, and product/UX strategy.

Some skills originated in the
[AI Coding Toolkit](https://github.com/benjaminshoemaker/ai_coding_project_base),
but this repository is the canonical home for the smaller, independent
capabilities I actually reach for. Skills here should remain useful without
adopting the toolkit's end-to-end delivery workflow.

## Skill Tiers

### Project Discovery

- `project-research` — Combine personal context, repository evidence, domain
  research, falsification, and competitive analysis into an informed point of
  view and the smallest useful next learning step.
- `design-directions` — Explore genuinely different visual territories, make
  them comparable, and turn the selected direction into a durable design
  language.

### Daily Feature Support

These show up in most feature work, especially as a feature gets close to done.

- `discover-flow-verification` — Design a repeatable verification harness for a
  specific user or integration flow.

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
  system guidance. Use `design-directions` first when the visual language itself
  is unsettled.
- `innovate` — Identify one high-leverage product or workflow improvement.

### Focused Review

- `security-scan` — Run dependency, secret, and project-native static-analysis
  checks without installing tools or applying fixes automatically.
- `tone-check` — Identify formulaic AI-writing markers and compare a document
  with reliable samples of the user's own writing.

### Skill Quality

This is mostly for maintaining skill repos and prompt systems.

- `audit-skills` — Audit skills, commands, and prompt templates for common
  quality issues.

## Use Skills Directly

This repository is a catalog, not a feature-development lifecycle. Install and
invoke only the capabilities that improve the task at hand.

- Use `project-research` when important domain, product, or competitive context
  is genuinely missing. Proceed directly when the work is already clear.
- Use `design-directions` when the visual language itself is unsettled.
- Use review, verification, audit, and context skills for their specific jobs;
  none is a prerequisite for another unless its own instructions say so.

## Installation

Clone the repo:

```bash
git clone https://github.com/benjaminshoemaker/bens_indispensable_skills.git
cd bens_indispensable_skills
```

List the available skills:

```bash
./install.sh --list
```

Install only the skills you want:

```bash
./install.sh --skill project-research --skill design-directions
```

By default, installation uses symlinks under `~/.claude/skills`. Repeating
`--skill` selects multiple skills. Installation requires an explicit
selection; use `./install.sh --all` only when you intentionally want the full
collection.

Common destinations:

- Claude Code: `~/.claude/skills/`
- Codex / agent runtimes using the agents layout: `~/.agents/skills/`
- Codex setups that read directly from Codex home: `~/.codex/skills/`

Install somewhere else:

```bash
./install.sh --dest ~/.agents/skills --skill project-research
```

Install by copying instead of symlinking:

```bash
./install.sh --method copy --skill project-research
```

Restart your agent after installing so it can reload available skills.

See [Compatibility](docs/compatibility.md) for per-skill requirements and common
agent skill directories.

## Quick Start

See [Quick Start](docs/quick-start.md) for a short walkthrough of:

1. Installing selected skills
2. Using Codex as a second model
3. Defining flow verification
4. Running milestone strategy skills

## Repository Contents

- [install.sh](install.sh) — Install by symlink or copy.
- [tests/test-install.sh](tests/test-install.sh) — Verify explicit selective and
  full-collection installation behavior.
- [Compatibility](docs/compatibility.md) — Per-skill requirements and caveats.
- [Quick Start](docs/quick-start.md) — A first workflow to try after installing.
- [Canonical Reconciliation](docs/canonical-reconciliation.md) — How skills
  were retained, promoted, or held during the toolkit transition.
- [LICENSE](LICENSE) — MIT license.
