# Scoring & Prioritization

## Severity Levels

### Critical (High)
Issues likely to cause **execution failures** - agent skips steps, produces wrong output, or fails silently.

Criteria: L1, C1, C2

**Action**: Fix before using skill in production.

### Medium
Issues that **degrade quality** but skill may still function. Agent works harder, context bloats, or output needs manual review.

Criteria: L2, L3, C3, S1, S3, E1, D1, D3

**Action**: Fix when maintaining skill or if issues observed in practice.

### Low
**Polish items** - skill works but could be cleaner or more robust.

Criteria: S2, E2, D2

**Action**: Fix opportunistically or during major revisions.

## Prioritization Rules

Within each severity level, prioritize by:

1. **Skill with most violations** - Fix holistically rather than piecemeal
2. **Most common violation** - Indicates systemic pattern; may warrant template fix
3. **Recently modified skills** - Higher likelihood of active use
4. **Skills with dependencies** - Fixing parent skills benefits children

## Quick Reference

| ID | Criterion | Severity |
|----|-----------|----------|
| L1 | Exceeds 500 lines | High |
| L2 | No progressive disclosure | Medium |
| L3 | Nested references | Medium |
| C1 | Missing checklist | High |
| C2 | No verification step | High |
| C3 | No feedback loop | Medium |
| S1 | Missing step headers | Medium |
| S2 | Critical rules not repeated | Low |
| S3 | Ambiguous execute vs read | Medium |
| E1 | No error handling | Medium |
| E2 | No way out | Low |
| D1 | Missing "when to use" | Medium |
| D2 | First/second person | Low |
| D3 | Vague description | Medium |
