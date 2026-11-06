---
name: iterate-prompts
description: Compare revisions to an existing prompt or agent pipeline against a frozen baseline and the user's quality criteria. Use for a feedback, edit, generate, and review loop; use prompt-audit for a text-only audit.
---

# Iterate prompts

Produce a demonstrated behavior improvement, or a clear decision to reject or defer a candidate.

Explain the relevant pipeline before editing: inputs, retrieval, generation stages, tool actions, handoffs, and the final saved or displayed result. Read the effective instructions, including shared references and embedded schema descriptions. Separate observed causes from hypotheses. Missing evidence, bad retrieval, wrong selection, and failed persistence require different repairs.

Use the latest user feedback to define success and the behaviors that must survive. Keep an experiment note with versions, conditions, judgments, and current status. An optional [comparison note](references/comparison-note.md) supplies the fields; reuse an existing record when available.

```text
- [ ] Define the target and responsible stage
- [ ] Pin the baseline, inputs, state, and execution conditions
- [ ] Review the candidate and run the authorized comparison
- [ ] Assess full outputs, regressions, failures, and saved state
- [ ] Record the decision and remaining limits
```

Hold model/settings, effective date, inputs, tool behavior, existing records, and code versions constant when isolating a prompt edit. Reset writable state between arms. An old stored answer is evidence, not a newly generated baseline. State whether the run creates fresh artifacts or incrementally updates existing ones: no new output can be correct when existing work already covers the need.

Make a focused revision to the stage responsible for the mismatch. Replace conflicting instructions rather than accumulate exceptions. Preserve output contracts and permissions. Present the exact baseline-to-candidate change before running it; honor the user's review requirements. Local execution authority does not authorize sending data to a new provider or changing a live prompt.

Generate both arms through the final artifact being judged. Show full paired outputs in a suitable local review surface when possible. A reviewed intermediate input can isolate a downstream defect, but label the result assisted and check the combined flow before claiming end-to-end success.

Assess material criteria against concrete output evidence. Count useful selections and omissions separately. Keep abstentions, timeouts, missing files, and failed attempts in the denominator. Successful exit status and valid JSON do not establish quality or a saved result. Verify persistence and readback when relevant; otherwise report generated or would-save status precisely.

Repeat unstable cases and reserve independent cases before repeated tuning. Several samples of one incident are not independent incidents. Label human judgments separately from provisional agent grading. Smaller output, polished language, or a higher model score alone is insufficient evidence of improvement.

Return the decision, changed behavior, strongest comparison evidence, regressions, conditions, and limits. Keep the best reviewable candidate when the runner or access fails, describe the blocker, and continue independent work. Separate publication from evaluation; follow the owning project's permissions.
