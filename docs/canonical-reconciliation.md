# Canonical Skill Reconciliation

Snapshot date: 2026-09-29

This repository is the canonical home for retained independent skills. The
former source toolkit, `ai_coding_project_base`, is being deprecated as an
end-to-end workflow.

## Reconciled Without Changes

These skill directories were identical between the two repositories at the
start of reconciliation:

- `audit-skills`
- `codex-consult`
- `codex-implement`
- `codex-review`
- `search-chats`
- `ui-ux`

Canonical ownership now belongs here. The former toolkit copies were removed
from its active tree after the preservation checkpoint.

## Reconciled With Improvements

- `data-flow-audit` received the toolkit's newer metric-first, empirical
  reconciliation workflow. Phase-checkpoint language was removed, baseline
  writes now require authorization, and inherited Markdown debt was repaired.
- `discover-flow-verification` received complete invocation metadata, a
  copyable workflow checklist, and an explicit blocked outcome when required
  context cannot be inspected.
- `design-directions` now stops after repeated unsuccessful direction rounds
  and has a clear path when product, reference, or rendering context is absent.
- `project-research` and `design-directions` originated directly in this
  canonical repository and have no toolkit copy.
- `innovate` received the toolkit's newer product-surface exploration,
  runners-up, and compounding/flywheel preference.

## Newly Promoted

- `security-scan` was promoted as an independent release and repository review
  capability. Phase coupling was removed, missing tools are not installed, fixes
  require separate approval, and suspected credentials must be redacted.
- `tone-check` was promoted with its session-parsing reference packaged inside
  the skill. It does not assign a personal-voice score without at least five
  reliable user-authored samples.

## Retired

These skills recreated the old toolkit's project-state and documentation
workflow, so they were removed from the canonical library:

- `capture-work`
- `triage`
- `work-status`
- `capture-session`
- `update-docs`

Their historical implementations remain available in Git history.

## Not Promoted in Current Form

Observed chat history made these toolkit-only skills worth inspecting, but
their present implementations are not independent enough to publish:

- `feature-audit` assumes feature specs, execution plans, four parallel
  research agents, Codex CLI configuration, and specific browser tooling.
- `code-verification` is an autonomous multi-agent fix-and-retry harness with
  workflow logging rather than a narrow verification skill.
- `create-pr` can stage all changes, create a commit, push, invoke other skills,
  and proceed past failed verification. It needs a safety and composability
  redesign before publication.

Other toolkit-only skills remain unpromoted until observed use or a concrete
request justifies maintaining them. The library should not absorb every
theoretically useful command from the old toolkit.

## Usage Evidence

A directional search of user-authored Claude Code and Codex session records
from the prior year found the following slash-form mentions among relevant
skills:

| Skill | Mentions |
|---|---:|
| `innovate` | 23 |
| `codex-consult` | 20 |
| `codex-review` | 17 |
| `feature-audit` | 16 |
| `code-verification` | 10 |
| `data-flow-audit` | 9 |
| `ui-ux` | 7 |
| `tone-check` | 5 |
| `security-scan` | 4 |
| `create-pr` | 3 |
| `capture-work`, `triage`, `update-docs`, `work-status` | 2 each |
| `audit-skills` | 2 |
| `codex-implement` | 1 |

These are mentions, not verified executions. User-provided instruction files can
also contain slash commands, so the counts guide review but do not prove value.

## Validation

The changed skill set was checked against the `audit-skills` criteria:

- no skill exceeds 500 lines;
- every multi-step workflow has a copyable checklist;
- quality-critical workflows include verification or a feedback loop;
- likely missing-tool, missing-context, and blocked paths are explicit;
- descriptions state concrete trigger conditions;
- local references resolve;
- no critical or medium audit findings remain in the changed skills.

The bundled skill validator could not run because both available Python
runtimes lack `PyYAML`. Equivalent YAML parsing was run with Ruby for all changed
frontmatter. Markdown lint, shell syntax checks, installer behavior tests, and
`git diff --check` pass.
