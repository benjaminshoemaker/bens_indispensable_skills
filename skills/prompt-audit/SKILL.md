---
name: prompt-audit
description: Audit prompts, skills, and agent instructions for fit with current model capabilities and the intended user experience. Recommend improvements to unnecessary coaching, obsolete assumptions, missing context, and conflicting responsibilities. Use for reassessing the approach; use prompt-maintainer for a targeted edit already chosen.
---

# Prompt Audit

Recommend instructions that improve the intended behavior and leave appropriate room for model judgment. Fewer words are useful only when they preserve or improve the result. Keeping a prompt unchanged is a valid conclusion.

## Establish the contract and context

Read the exact prompt and identify its source or version, intended outcome, audience, completion condition, and important constraints. Distinguish the user's actual requirements from assumptions embedded in the prompt. Existing process rules may themselves need reconsideration; propose such changes explicitly while preserving the user's authority and genuine operational requirements.

Establish the target model and relevant runtime context where available: supplied information, shared instructions, tools, downstream stages, and representative outputs. Inspect dependencies only far enough to assess consequential duplication or conflict. For a standalone pasted prompt, give a bounded text audit and identify what cannot be established without its runtime; do not invent missing context or require a full system investigation.

Consult [illustrative patterns and model guidance](references/lessons-and-model-guidance.md) when examples would help assess a finding. Before making a model-specific recommendation, check current official guidance for the actual target model. Treat dated guidance as a starting point. If the model or documentation is unavailable, keep those recommendations conditional and continue with supported findings.

## Evaluate what changes behavior

Apply the relevant judgments; do not manufacture a finding for every category:

- **Purpose and completion:** Is success explicit? Does a required interview, checklist, or follow-up continue after the user's goal is satisfied?
- **Specificity and discretion:** Does each instruction encode a meaningful requirement, or coach reasoning and routine choices the model can handle? Examine fixed sequences, exhaustive examples, emphatic tool mandates, personas, and blanket research or verification requirements. Preserve structure that serves the user or a real dependency.
- **Context and responsibility:** What does the model already know or receive elsewhere? Look for missing product knowledge, stale capability assumptions, conflicting instructions, and behavior owned by tools or the application. Recommend moving a rule only after identifying its intended owner; do not assume moving it makes it enforced.
- **Interaction and output:** Do instructions induce redundant questions, unnecessary prerequisites, excessive work, or internal terminology in user-facing answers? Preserve useful detail, evidence, and necessary clarification.
- **Model fit:** Could stronger instruction following amplify an old workaround? Does the target model need different steering? Age, length, and model capability alone do not prove an instruction is unnecessary.
- **Cause:** Separate prompt defects from unavailable inputs, retrieval gaps, lost instructions, tool limitations, and execution failures. Do not prescribe stronger wording for instructions that never reach the responsible stage.

## Recommend and check

Prioritize by likely effect on the user's result. For each material finding, identify the relevant passage and recommend keeping, removing, simplifying, moving, or adding instructions. Explain the expected behavior change, supporting evidence, and meaningful regression risk. Distinguish observed behavior, documented model guidance, and hypotheses.

Prefer replacing or consolidating language over adding patches. Add missing guidance when it resolves a consequential gap. A broader redesign can be appropriate when the current contract is wrong; explain why a local edit would be insufficient. Do not turn individual past failures into universal prohibitions.

Use available examples to reason through intended behavior, an excluded case, and a boundary where the original instruction remains useful. Label reasoned checks accurately. Where uncertainty matters, suggest a representative comparison with the baseline, holding model and runtime settings constant. Do not require a formal evaluation harness for an ordinary audit.

## Deliver the audit

Lead with the overall assessment and the few changes most worth making. Include concise replacement wording or a minimal diff where it makes a recommendation reviewable, plus any runtime dependency or uncertainty that changes the decision. Do not impose a numerical score, finding quota, or mandatory rewrite.

Audit and suggest by default; do not modify the audited artifact or live prompt unless asked. When the user chooses a revision, use `prompt-maintainer` if available. Otherwise, apply the smallest coherent change that preserves the agreed purpose, boundaries, and output requirements, then check for duplication and conflicts. Keep proposed, applied, and tested changes distinct.
