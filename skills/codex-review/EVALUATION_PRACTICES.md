# Evaluation Best Practices

For reliable independent review, follow these patterns.

## Rubric-First Approach

Define clear evaluation criteria in the prompt before asking for review. The prompt template uses structured categories (Correctness, Best Practices, Consistency, Documentation, Potential Issues) as a rubric.

## Severity Classification

Use consistent severity levels:
- **CRITICAL**: Blocks progress, must be addressed
- **RECOMMENDATION**: Should be considered, doesn't block
- **POSITIVE**: Reinforces good patterns

This aligns with [OpenAI's evaluation best practices](https://platform.openai.com/docs/guides/evaluation-best-practices) for LLM-as-judge patterns.

## Handling Review Disagreement

When the parent agent and Codex reviewer disagree, follow these guidelines:

| Scenario | Action |
|----------|--------|
| **Both agree: PASS** | Proceed when the verification evidence supports it |
| **Both agree: NEEDS_ATTENTION** | Address the supported issues |
| **Parent: PASS, reviewer: NEEDS_ATTENTION** | Review Codex's specific findings — it may have researched current docs |
| **Parent: NEEDS_ATTENTION, reviewer: PASS** | Check the specific concern against the code and tests |
| **Conflicting critical issues** | Present both perspectives to user for decision |

## Disagreement Signals

- If reviewers disagree on >50% of findings, flag for human review
- If one reviewer finds critical issues the other missed, always surface them
- Never silently discard findings from either reviewer

## Resolution Strategies

1. **Union approach** (default): Surface all unique findings from both reviews
2. **Intersection approach**: Only flag issues both reviews identified (higher precision, lower recall)
3. **Weighted approach**: Weight findings by supporting evidence and relevant context

**When in doubt:** Present disagreements to the user with context from both reviews. The goal is catching blind spots, not achieving false consensus.

## Status Mapping

| Codex Status | Meaning | Checkpoint Action |
|--------------|---------|-------------------|
| `pass` | No issues found | Continue, note in report |
| `pass_with_notes` | Minor recommendations only | Show recommendations, continue |
| `needs_attention` | Critical issues found | Show issues, ask user how to proceed |
| `skipped` | Codex unavailable | Note unavailable, continue |
| `error` | Codex failed | Note error, continue |

## Advisory Nature

Codex findings are **advisory** — they do not auto-block workflows. The user decides whether to address findings or accept them as noted risks. This prevents false positives from blocking legitimate work.
