---
name: data-flow-audit
description: Audit how data is computed, stored, and served to catch numbers that are wrong today or structured to drift — duplicate computations, stale derived values, split data sources, cross-layer formula divergence. Verifies suspected divergence empirically, not just structurally. Use before a risky merge, when two views disagree on a number, or when investigating data consistency issues.
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, AskUserQuestion
---

# Data Flow Audit

Catch data being computed incorrectly. The failure mode this targets: the same
business number is computed or stored in more than one place, the
implementations drift, and different parts of the app start showing different
values. This happens on both the **read path** (two endpoints/components derive
the same metric independently) and the **write path** (a derived or denormalized
value has multiple writers, or a writer that some update paths skip).

The audit produces two tiers of evidence, and severity follows evidence:

1. **Confirmed divergence** — the same metric was computed through two paths against the same data and the values disagree *today*. This is the headline finding; everything else supports it.
2. **Divergence-prone structure** — duplicate computation that happens to agree now but has no shared definition keeping it that way.

A static scan alone only produces tier 2. Step 4 (empirical reconciliation) is what turns "these could disagree" into "these do disagree" — do not skip it for the top candidates.

## Principles

- **Discover, don't assume.** Every shell command in this skill and in
  [DETECTION_PATTERNS.md](DETECTION_PATTERNS.md) is a worked example from
  *some* stack, not the procedure. Step 1 discovers this project's actual
  storage, query idioms, and layout; derive the equivalent searches from that.
  If a pattern does not exist in this project, translate the technique rather
  than running the example verbatim and reporting "no findings."
- **The metric inventory is the core artifact.** Findings are statements about metrics ("carry cost is computed in 3 places, 2 agree"), not about files. Build the inventory first; everything else annotates it.
- **Evidence outranks volume.** One confirmed wrong number matters more than ten consistent duplications. Never let structural findings crowd confirmed ones out of the report.
- **Incremental by default.** Findings that were reported and accepted go in a baseline file; re-runs validate the baseline and surface only what's new. An audit that re-fails every run on known debt trains people to ignore it.

## Modes

Pick based on how the audit was invoked:

| Mode | When | Scope |
|------|------|-------|
| **Quick check** | Pre-merge or review of a bounded change | Validate baseline entries + run detection only on files changed since the last audit + mock-divergence pre-check |
| **Full audit** | First run on a project, or explicit request | All steps, whole codebase |
| **Targeted** | "Why do these two numbers differ?" | Steps 1–2 scoped to that metric, then straight to Step 4 reconciliation |

## Workflow

```
Data Flow Audit:
- [ ] Step 0: Load and validate the baseline (if present)
- [ ] Step 1: Discover the data architecture
- [ ] Step 2: Build the metric inventory
- [ ] Step 3: Flag structural risks (read path, write path, early warnings)
- [ ] Step 4: Reconcile top candidates empirically
- [ ] Step 5: Report; update the baseline
```

### Step 0: Load and validate the baseline

Look for `.claude/data-flow-baseline.md` in the project (format in DETECTION_PATTERNS.md §7). It records two kinds of entries: **known rules** (a business rule with its canonical definition and tracked locations) and **accepted findings** (previously reported issues the team chose to live with).

For each known rule, verify the canonical location still exists, re-check each
tracked location for the rule's conditions, and search for untracked locations
using the fingerprint method in §2.3. Flag DRIFTED if any location no longer
matches the canonical definition; that is a CRITICAL candidate for Step 4. For
each accepted finding, confirm it still describes reality and drop entries that
no longer apply.

No baseline file → note it, continue; offer to create one in Step 5.

### Step 1: Discover the data architecture

Answer these questions by inspecting the project (README, config, dependency manifests, directory layout), and write the answers down — they parameterize every later search:

- **Where does data live?** Databases, files (CSV/JSON/SQLite), caches, external APIs, generated static files.
- **How is it queried?** The actual idiom: an ORM (which one, what do calls look like), raw SQL, a client library, pandas, file reads. Record the concrete syntax of a query, a filter, and a write in this codebase.
- **Where is it computed?** API routes, background jobs, build/ETL scripts, SQL functions/views, frontend code.
- **How does it get in?** Ingest scripts, migrations, scrapers, manual imports.
- **How does it reach the user?** Server endpoints, static generation, direct client queries.

If the project genuinely has no stored or served data, report NOT APPLICABLE
with one sentence of justification and stop. A static site generated from data
files, or a script pipeline, *is* in scope: its lifecycle is ingest → transform
→ generate rather than request → query → respond, but the failure modes are the
same.

### Step 2: Build the metric inventory

Enumerate the business numbers this app stores or displays — metrics, totals, rates, scores, counts, statuses derived from data. Sources: the display layer (what's on screen), the schema (stored derived columns), and the computation sites found in Step 1.

For each metric, record every site that computes or persists it:

```
| Metric | Definition (in words) | Sites (layer — file:line) | Stored? (where) | Notes |
```

A metric with one computation site and no stored copies is done — skip it in Step 3. The audit's subjects are metrics with 2+ sites, or 1 site plus a stored/denormalized copy.

Cap the inventory sensibly: in full-audit mode aim for complete coverage of *displayed* metrics; in quick-check mode only inventory metrics touched by the changed files.

### Step 3: Flag structural risks

Work through the pattern catalog in [DETECTION_PATTERNS.md](DETECTION_PATTERNS.md), translating each technique to the idioms recorded in Step 1:

- **Read path** (§2): split data sources, aggregation cascades, scattered filter predicates (normalized fingerprint matching), cross-layer formula and constant duplication, shared-library bypass, duplicated types/helpers.
- **Write path** (§3): derived-value writer audits (does every path that changes the inputs also update the derived value?), snapshot/rollup freshness, double writes, unit/representation drift at storage boundaries.
- **Early warnings** (§4–5): frontend consumer conflicts, test-mock divergence. Mock divergence is cheap — in quick-check mode run it *first*; consistent mocks lower the urgency of everything else.

Attach each finding to a metric in the inventory. A structural finding with no nameable metric behind it ("these two files look similar") is probably noise — either identify what number is at risk or drop it.

### Step 4: Reconcile empirically

For each CRITICAL/HIGH candidate, attempt to confirm or clear it (methods in DETECTION_PATTERNS.md §6): compute the metric through each implementation against the same real data and compare — run both paths where possible, hand-trace one concrete record where not. Record the actual values.

- Values disagree → **CRITICAL (confirmed)**, report the concrete example.
- Values agree → downgrade to consistent-duplication (MEDIUM/HIGH per the table below), note "reconciled OK on {example}".
- Reconciliation infeasible (no data access, can't execute) → keep the structural severity and state explicitly that it is unconfirmed and why.

Reconcile at minimum the top 3 candidates; in targeted mode, reconciliation of the metric in question is the whole point.

### Step 5: Report and update the baseline

**Severity:**

| Severity | Meaning |
|----------|---------|
| CRITICAL | **Confirmed divergence** — same metric, different values, demonstrated on real data. Also: a baseline known-rule whose canonical definition has drifted. |
| HIGH | Divergence-prone and unprotected: independent implementations with no shared definition, a stored derived value with an incomplete writer set, or a shared helper that most call sites bypass. Not yet confirmed diverged (or unconfirmable). |
| MEDIUM | Duplicated but currently consistent (verified or low-risk); test-mock divergence; bypass with a plausible reason. |
| LOW | Documented, intentional duplication. |

**Exit criteria:**

| Result | Condition |
|--------|-----------|
| FAILED | Any confirmed divergence, or a **new** HIGH finding introduced by the work under review |
| PASSED WITH NOTES | Pre-existing HIGH findings already in the baseline; new MEDIUM/LOW findings |
| PASSED | Nothing new beyond the baseline |

**Report format** — findings first, ordered by severity; inventory and maps as appendix, not headline:

```
DATA FLOW AUDIT — {mode} — {PASSED | PASSED WITH NOTES | FAILED}
Metrics inventoried: {N}   Multi-site metrics: {N}   Reconciled: {N}   Baseline entries validated: {N}

FINDINGS
1. {Metric} — {CRITICAL|HIGH|MEDIUM|LOW} {(confirmed: X vs Y on {example}) | (unconfirmed: {reason})}
   Sites: {layer — file:line, ...}
   Pattern: {split source | writer gap | cross-layer formula | scattered predicate | ...}
   Fix: {specific consolidation: extract to X | designate Y authoritative | add writer in Z}

BASELINE: {N validated, N drifted, N stale-removed, N new entries proposed}

APPENDIX: metric inventory table
```

**Fix recommendations** should name the consolidation move: extract a shared
function/module and migrate call sites; designate one implementation
authoritative and make others delegate; move the constant to one named
definition; add the missing writer or replace the stored copy with on-read
computation; have the parent fetch once and pass down.

Finally, propose baseline updates: new accepted findings (only with user
confirmation), new known rules for anything consolidated, and removal of stale
entries. Update the file only when the request authorizes repository changes;
otherwise report the proposed changes. If none existed, offer to create it.

## Error handling

| Situation | Action |
|-----------|--------|
| Can't determine the stack in Step 1 | Ask the user rather than guessing — everything downstream depends on it |
| No data access for Step 4 | Report structural findings as unconfirmed; suggest the specific query/command the user could run to confirm |
| >5 findings | Full detail for the top 3 by severity; one line each for the rest |
| Inventory would exceed ~30 multi-site metrics | Prioritize displayed + stored metrics; list what was skipped |

## Limitations

- Cross-service and external-API duplication is out of scope (single-repo analysis).
- Fingerprint matching normalizes naming (§2.3) but still misses duplication that renames *and* restructures; reconciliation (Step 4) is the backstop.
- Reconciliation requires runnable access to data; without it the audit is structural-only and says so.
