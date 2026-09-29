---
name: project-research
description: Explore a domain, test a thesis, compare opportunities, or shape an early product direction when important context is still incomplete. Use for research that combines the user's perspective with repository evidence, current external sources, and competitive analysis; skip bounded implementation tasks and questions repository inspection alone can settle.
---

# Project Research

Develop a well-supported point of view or decision when important domain or
product context is incomplete. Combine the user's experience with relevant
project evidence, current external research, and active falsification. Preserve
useful conclusions without creating a document pipeline.

## Principles

- Treat the user as the source of experience, preferences, constraints, and
  decisions; investigate independently discoverable facts before asking.
- Inspect relevant project context before researching or questioning, and treat
  historical artifacts as evidence rather than current authority.
- Support current factual claims with direct, authoritative sources. Distinguish
  evidence, inference, hypothesis, preference, and decision when it matters.
- Seek the strongest counterexample or nearest substitute before recommending a
  direction. Absence from search results is not evidence of an open gap.
- Keep questions, research depth, and durable artifacts proportional to the
  uncertainty and consequence of the decision.
- Preserve the selected research mode; do not turn exploration into product
  selection or research into implementation without the user's direction.

## Workflow

```text
Project Research Progress:
- [ ] Frame the inquiry
- [ ] Inspect context and investigate evidence
- [ ] Update the working view and ask material questions
- [ ] Recommend the smallest useful next learning step
- [ ] Preserve durable context only when it will remain useful
```

### 1. Frame the Inquiry

Establish a compact research contract:

- **Mode:** explore a domain, test a thesis, compare independent opportunities,
  or gather evidence for a decision.
- **Unit of analysis:** state exactly what is being studied or compared; do not
  mix a model, product, company, workflow, and user outcome as equivalent units.
- **Starting view:** capture what the user currently believes and which parts
  come from experience or taste.
- **Falsification target:** identify the evidence, counterexample, substitute,
  or practical constraint that would materially change that view.

Define a small set of research questions. Keep independent ideas in separate
lanes unless the user asks to combine them or evidence reveals a necessary
dependency. Change modes only when the user requests or accepts the transition.

If the remaining uncertainty is already cheaper to resolve with a reversible
prototype, recommend that instead of manufacturing more discovery work.

### 2. Inspect Context and Investigate Evidence

When a repository or prior artifact exists, inspect the most relevant product
documentation, interface, code, decisions, and research. Identify the current
source of truth and note stale or conflicting artifacts.

Investigate facts before asking the user. Depending on the inquiry, examine
primary sources, users and their workarounds, direct and adjacent competitors,
technical constraints, and relevant interaction precedents.

For a product or opportunity claim, verify:

- the closest substitute and the outcome it actually delivers;
- whether the evidence describes a live product, beta, waitlist, announcement,
  demo, or unbuilt concept;
- capability separately from traction, adoption, retention, or outcomes;
- operational, regulatory, distribution, and trust constraints;
- comparisons at the declared unit of analysis.

Describe material search boundaries. If repository access, browsing, or a
necessary source is unavailable, state the limitation and keep unsupported
claims labeled as hypotheses.

### 3. Update the Working View and Ask Material Questions

Track only hypotheses that could change the direction. For each, retain its
current status, strongest evidence and counterevidence, and cheapest decisive
next test. Use a ledger or table only when several hypotheses or multiple
sessions make that state hard to hold in the conversation.

Periodically synthesize:

- the current view and why;
- what has been supported, weakened, or falsified;
- what remains uncertain;
- the most useful next question, test, or prototype.

Ask the user for experience, preferences, constraints, and decisions—not facts
that can be investigated. During exploration, deepen the map rather than force
a product choice. During testing or decision work, stop questioning when the
remaining uncertainty is cheaper to resolve through research, prototyping, or
implementation.

### 4. Recommend the Next Learning Step

Recommend the smallest outcome justified by the evidence:

- proceed when the next change is clear and reversible;
- prototype when experience, feasibility, or taste needs something concrete;
- run focused research when one factual uncertainty remains decisive;
- preserve context when conclusions will matter across sessions;
- create a bounded plan only when the accepted next step has meaningful
  dependencies, coordination, or risk.

Do not automatically implement the recommendation. Continue only when the
original request includes implementation or the user confirms the transition.

### 5. Preserve Durable Context When Useful

Keep bounded research in the conversation. For work that must survive across
sessions, update the project's existing canonical context artifact. If none
exists, propose `PROJECT_CONTEXT.md` before creating it.

Preserve only what future work needs: research mode and unit, current thesis,
material evidence and counterevidence, corrections, decisions and rationale,
open questions, and the next test. Reconcile material changes into this source
of truth and mark stale or superseded conclusions rather than leaving competing
artifacts that appear current.

Write only when authorized. For read-only work, report the reconciliation that
would be needed. After writing, read the artifact back and confirm that it
preserves sources and does not promote hypotheses into decisions.

## Final Check

Before concluding, verify that:

- current factual claims are sourced and important uncertainty is explicit;
- the mode and unit of analysis remained consistent;
- the strongest known substitute or counterexample was considered;
- capability, product status, and traction were not conflated;
- the user's perspective remains distinct from external evidence;
- the recommendation follows from the current view;
- durable context, when used, reflects material corrections.

If the evidence does not support a confident conclusion, report what is known,
what remains uncertain, and the cheapest next way to learn.
