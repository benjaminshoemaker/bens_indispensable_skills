---
name: prepare-pr
description: Prepare an existing implementation or revised pull request for engineering review by reconciling intent, scope, current base, reviewer feedback, and relevant verification. Excludes upfront feature planning.
---

# Prepare a pull request

Turn a working change into a contribution another engineer can assess. Execute the necessary local preparation within the authorized scope.

```text
- [ ] Recover intended behavior and current checkout/base/PR state
- [ ] Check scope, existing patterns, and substantive reviewer requests
- [ ] Verify the affected behavior and resolve demonstrated issues
- [ ] Prepare concise review text and report readiness
```

Read repository instructions. Inspect branch, uncommitted edits, upstream freshness, PR head, and reviewer commits before integrating anything. Identify the task's diff explicitly; preserve unrelated work and existing review history. Coordinate a branch restructuring once review is underway.

Compare the final implementation with the user's accepted scope. Look for existing components, libraries, assets, and configuration patterns before accepting new ones. A small file count does not make a change narrow: check whether telemetry changes a primary response, visual cleanup hides information, or a fix changes shared behavior.

For an existing PR, account for inline threads, review bodies, and conversation comments against the latest code. Mark each substantive request addressed, intentionally retained with a reason, or open. Treat AI review findings as hypotheses requiring a concrete affected contract or credible failure. Surface consequential product or architecture choices instead of silently expanding scope.

Run the relevant existing checks and exercise the boundary where the claim occurs. Choose coverage from the reported failure, normal behavior, affected callers, and meaningful state transitions. Use real SDK behavior when helpers cannot establish the result. Reuse earlier verification only when its revision and conditions still apply.

Diagnose failures before editing. Compare with the unchanged base when a failure may predate this work. Distinguish local helper, integration, provider, and deployed evidence. A placeholder is not generated content; a deployment record is not proof that the running service contains the revision. If proof is blocked, record the exact missing condition and finish independent preparation.

Draft purpose-first PR text: the user's current problem, resulting behavior, and reason it matters. Follow the repository's template and include only implementation details, validation, dependencies, and limitations that affect review. Rewrite around final scope after revisions. Keep conversational history and abandoned approaches out unless they explain a real tradeoff.

Report ready for review, needs work, or ready with stated verification gaps, tied to the assessed revision. Include the prepared text, resolved/open feedback, actual checks, and next action. Readiness does not authorize a push, publication, merge, message, or deployment; apply the project's approval boundaries.
