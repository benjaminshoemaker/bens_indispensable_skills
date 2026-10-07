# Illustrative patterns and model guidance

These examples illustrate audit judgments. They are not measured results or instructions to add to every prompt.

## Patterns

| Situation | Audit judgment | Boundary to preserve |
|---|---|---|
| A prompt requires a full intake interview even when the task and inputs are already clear. | Remove redundant questions; ask only for consequential missing information. | Do not assume a subject, audience, or goal that the available context does not establish. |
| An agent instruction file contains old setup failures, tool names, and retired workflows. | Verify whether they still affect current work; remove obsolete instructions. | Retain necessary local facts, permissions, and operational dependencies. |
| Every report prompt repeats the same research procedure. | Identify whether a shared instruction already owns that behavior before deleting duplicates. | Moving a rule to another file does not establish that the responsible agent receives it. |
| Generic coaching requires elaborate reasoning, fixed checklists, or repeated verification on every task. | Keep only structure that improves the requested result or prevents a concrete failure. | Useful schemas, acceptance criteria, and critical checks should survive simplification. |
| Internal labels such as "decision boundary used" appear in customer-facing answers. | Specify the information the reader needs in ordinary language. | Preserve necessary explanations and uncertainty. |
| An agent loses requirements during summarization or never receives the governing instructions. | Inspect instruction delivery and downstream context before rewriting the prompt. | Do not blame model capability or fix missing inputs with stronger wording. |
| A short prompt already produces the intended result. | Keeping it unchanged is valid. | Do not manufacture findings to justify the audit. |

## Model-specific claims

Establish the actual target model and runtime before attributing behavior to a model. Consult current official documentation for that model when making a model-specific recommendation. Do not substitute a different model or treat age, length, or a newer model as proof that an instruction is unnecessary.

Official starting points:

- [OpenAI reasoning guidance](https://developers.openai.com/api/docs/guides/reasoning-best-practices).
- [Anthropic prompting guidance](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices).

Documentation is evidence about supported guidance, not a controlled test of the audited workflow. If current documentation or the model identity is unavailable, keep model-dependent recommendations conditional and continue with findings supported by the prompt and observed behavior.

For uncertain changes, compare representative requests with the original and revised prompts while holding model and runtime settings constant. Distinguish observed results from reasoned checks; an ordinary audit does not require an evaluation harness.
