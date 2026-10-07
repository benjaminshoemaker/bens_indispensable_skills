---
name: prompt-maintainer
description: Refine an existing agent or system prompt while preserving its governing principles and preventing instruction bloat. Use when modifying a prompt after observed successes, failures, edge cases, or changing requirements. Exclude creating a prompt from scratch or building a formal evaluation system.
---

# Prompt Maintainer

Make the smallest coherent change that addresses the user's evidence without turning the prompt into a history of accumulated patches.

## Principles

- Treat the prompt as a behavior contract, not a changelog or repository for every lesson learned.
- Preserve the original purpose, important boundaries, stage responsibilities, and output contract unless the user explicitly changes them.
- Distinguish prompt failures from failures in inputs, retrieval, tools, orchestration, or downstream stages before editing.
- Prefer replacing, generalizing, consolidating, or deleting existing language over appending another rule.
- Keep only instructions that materially change behavior. Do not restate facts the agent can reliably infer from its inputs or environment.
- Use simple, direct, category-level decision boundaries. Define a category by the condition that makes an item belong; keep examples only when they clarify materially distinct behavior instead of forming a long or seemingly exhaustive list.

## Workflow

1. Read the exact current prompt and the user's requested change or observed behavior. Record the version or source when one exists.
2. Extract a compact prompt contract:
   - purpose;
   - governing principles;
   - positive and negative decision boundaries;
   - responsibility of this prompt relative to other stages;
   - required output.
3. Diagnose why the current prompt produced the behavior. State when the evidence does not show that the prompt itself is responsible.
4. Draft the smallest revision that addresses the cause. As a heuristic, when adding a sentence, look for an existing sentence it can replace or subsume.
5. Run a conservation pass:
   - confirm every governing principle is preserved or intentionally changed;
   - remove duplication and newly obsolete language;
   - check for contradictions and overlapping responsibilities;
   - remove explanatory prose that belongs in version notes rather than runtime context.
6. When examples are available, compare the revision against at least one expected-positive, expected-negative, and boundary case. This may be a reasoned spot check; do not require an evaluation harness unless the user asks for one.

## Response

Give the user:

- the governing principles you preserved;
- a short diagnosis of the problem;
- a minimal diff;
- the complete revised prompt when requested;
- any plausible regression or unresolved ambiguity.

Do not silently rewrite the prompt more broadly than requested. Do not add case-specific language merely to force one observed example. If the prompt is stored in a versioned or live system, distinguish the draft, latest, and production versions. Do not change the stored prompt unless the user explicitly asks to apply the reviewed revision.
