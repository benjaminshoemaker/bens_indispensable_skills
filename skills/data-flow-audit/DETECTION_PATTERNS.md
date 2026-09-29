# Detection & Reconciliation Methods

Reference for Steps 3–5 of the data-flow-audit skill.

**Every shell command below is a worked example from a particular stack.** The
examples use a Supabase/Next.js app and a Python/static-site pipeline. The
technique is the deliverable; the command is an illustration. Translate each
one to the query idioms, directories, and naming recorded in Step 1 before
running anything. If a technique needs clustering, co-occurrence counting, or
cross-file comparison, write a small throwaway script in the scratchpad instead
of forcing it through shell one-liners.

## §1 Building the metric inventory

Work backwards from outputs, forwards from schema:

1. **From the display layer**: list every number/status the UI or generated output shows. Each is a metric.
2. **From storage**: list stored columns/fields that are *derived* (totals, counts, scores, flags computed from other data) rather than raw facts. Each stored derived value is a metric with at least one persistence site.
3. **From computation sites**: scan the sites found in Step 1 for arithmetic on business fields, aggregate queries (`SUM`, `COUNT`, `GROUP BY`, `.reduce(`, `groupby`), and constants used in formulas. Map each back to a metric.

For each metric, find all sites with a normalized-identifier search (see §2.3 for normalization): search for the metric's key field names in *all* languages/layers at once, then classify each hit as compute / persist / display / mention-only.

## §2 Read-path patterns

### §2.1 Split data sources

The same business concept served through 2+ independently maintained code paths.

Detection: group data-serving code (endpoints, jobs, generation scripts) by the tables/files/entities they read. Within a group, flag:

- **BFF pairs** — list/detail, dashboard/overview, or job/endpoint pairs that compute overlapping fields independently instead of sharing a function.
- **Aggregation cascades** — an overview computes `SUM(metric)` with its own
  formula while per-item paths compute the metric individually. If the per-item
  formula changes, the total stops matching the sum of its parts. Reconcile by
  comparing the aggregate against the summed per-item values directly (§6).

```bash
# Example (Supabase/TS): who reads which table
grep -rn "\.from(\|\.rpc(" src/ trigger/ --include="*.ts" | grep -v test
# Example (Python pipeline): who reads which data file
grep -rn "read_csv\|json.load\|open(" scripts/ --include="*.py" | grep -iv test
```

### §2.2 Cross-layer formula and constant duplication

The same formula or business constant maintained independently in 2+ layers (SQL + app code, backend + frontend, ETL script + display template).

Detection — discover the constants, don't assume them:

1. In each computation site, collect numeric literals and thresholds that appear in business logic (rates, day counts, cutoffs, divisors like `/ 365`). Ignore obvious non-business values (0, 1, array indices, HTTP codes).
2. For each collected constant, search every other layer for the same value *and* for near-misses (a different value attached to the same concept name — that's the divergence case).
3. For formulas: identify the computation's inputs and operation in one layer, then search other layers for the same inputs combined differently.

Severity: different values for the same concept across layers → CRITICAL candidate, go to §6. Same value hardcoded in multiple places with no shared named definition → HIGH.

### §2.3 Scattered filter predicates (fingerprint matching)

The same business rule — a cluster of filter conditions — reimplemented across files/languages. This catches "what counts as an active listing / a valid record / a major event" being defined in N places.

1. **Extract**: for each file in scope, collect the field names used in filter contexts (WHERE clauses, `.eq()/.filter()` chains, `df[df[...]]` masks, `if row[...]` guards — whatever Step 1 found as this project's filter idioms).
2. **Normalize identifiers before comparing**: lowercase and strip `_`, `-`,
   and quotes, so `sold_date` ≡ `soldDate` ≡ `"SoldDate"`. Cross-layer renames
   are common at SQL↔code boundaries, and unnormalized matching misses them.
   Keep a map from normalized → original spellings for the report.
3. **Cluster**: find sets of 3+ normalized field names co-filtered in 3+ files. Do this with a throwaway script (extract per-file fingerprint sets, intersect pairwise), not by eyeballing grep output. Exclude infrastructure fields (`id`, `created_at`, `updated_at` and this project's equivalents).
4. **Validate**: read each clustered file and confirm it *filters* on the fields — discard hits that are type definitions, SELECT/projection lists, comments, or test mocks (mocks are captured separately, §5).
5. **Compare conditions**: within a validated cluster, list each site's actual conditions. Sites with the same fields but different conditions (one checks 3 of 4 conditions, one uses `>` where another uses `>=`) are drifted — CRITICAL candidates for §6.

Report per cluster: conditions, canonical helper (if any), each location with MATCH/PARTIAL/DRIFTED, and the fix (extract a canonical helper, or migrate bypassing sites to the one that exists).

### §2.4 Shared-library bypass

A shared module/helper encapsulates a query or rule, but some call sites hit the underlying data directly.

1. For each shared data module (service files, canonical SQL functions/views, shared query helpers), record what it wraps.
2. Search for direct access to those same tables/files/fields outside the module.
3. Flag non-importing sites. Bypass can be intentional (different column subset, different join context) — record the justification and rate MEDIUM; unexplained bypass is HIGH because the shared module will evolve without the bypasser.

### §2.5 Duplicated types and helpers

Cheap corroborating signal: two type/dataclass definitions in different serving
files sharing most of their fields, or same-named utility helpers
(`parseNumeric`, `formatRow`, date formatters) defined locally in multiple
files. This is rarely a headline finding by itself; use it to strengthen a
split-source finding and name the extraction target.

## §3 Write-path patterns

The read path asks "who computes this?"; the write path asks "who keeps this stored value correct?"

### §3.1 Derived-value writer audit

For each *stored derived* value in the metric inventory (denormalized totals, cached counts, status flags, precomputed scores):

1. Enumerate its **writers** — every code path that sets or updates it (inserts, updates, triggers, batch jobs, ingest scripts).
2. Enumerate its **input-mutation paths** — every code path that changes the underlying data it's derived from.
3. Diff the two sets. An input-mutation path with no corresponding derived-value update is a **writer gap**: the stored value goes stale exactly when that path runs. HIGH, and a prime reconciliation candidate — recompute from inputs and compare to the stored value (§6).
4. If there are 2+ writers, compare their formulas like §2.2 — multiple writers with different formulas means the stored value depends on which path wrote last (CRITICAL candidate).

### §3.2 Snapshot and rollup freshness

For snapshot tables, rollup/aggregate tables, materialized views, and generated
data files: who refreshes it, on what trigger, and does anything read it beside
live-computed values? A page mixing a stale rollup with a live query shows
inconsistent numbers even when each source is individually "correct." Flag
rollups with no discoverable refresh owner (HIGH). Reconcile mixed stale/live
reads by comparing rollup and live values on current data.

### §3.3 Double writes and multi-store sync

The same fact persisted to 2+ places (two tables, DB + cache, DB + generated JSON) by different code paths. Check that a single code path owns both writes; if different paths write each copy, they *will* diverge on partial failure or code drift. Reconcile by diffing the two stores directly.

### §3.4 Boundary representation drift

At each storage/serialization boundary, check the same field for unit changes
(cents vs dollars, seconds vs ms), timezone/date handling, numeric type, rounding
at different stages, and null conventions (`null` vs `0` vs omitted). These
produce small divergences that survive casual inspection. When reconciling in
§6, compare exact values rather than eyeballing them.

## §4 Frontend consumer conflicts

Map data consumers (fetch/query calls, or template variables in a generated site) to their sources. Flag:

- **Same page, different sources** — two components on one page showing overlapping data from different endpoints/queries: the highest-risk case, because divergence is visible side by side. CRITICAL candidate; reconcile the two responses directly.
- **List vs detail divergence** — same metric fetched from different endpoints across navigation (HIGH).
- **Redundant child fetches** — parent and child independently fetching related data instead of the parent passing it down (MEDIUM; fix is the prop/callback pattern).

## §5 Test-mock divergence (early-warning pre-check)

When two test files mock the same business entity with different shapes, the code under test models the same concept differently. Cheap to check — in quick-check mode run this *before* the heavier steps.

Within each group of related test files, compare mocks of the same entity for
field-name differences beyond expected casing, type differences (`15000` vs
`"15000"`), null-convention differences, and wrapper-shape differences (nested
vs flat, array vs object). Also compare mocked endpoint URLs that return the
same entity.

Severity MEDIUM always — it's a symptom pointing at a split, not the split itself. Divergent mocks → prioritize that entity's metrics in Steps 2–4. Consistent mocks → weak evidence of health, not proof.

## §6 Empirical reconciliation

The step that converts "could diverge" into "does diverge." For each candidate, get the same metric from each implementation **for the same underlying data** and compare exact values.

Methods, in order of preference:

1. **Run both paths.** Execute each implementation against the real data store (run the SQL function and the app-code equivalent; call both endpoints; run the ETL computation and query the stored result). Diff exact values.
2. **Golden entities.** Pick 2–3 concrete entities (a specific player, order, community). Compute the metric for each entity through every path. Small sample, but divergence found this way is conclusive, and formula differences usually show up on any entity.
3. **Aggregate vs sum-of-parts.** For aggregation cascades: fetch the overview total and the per-item values, sum the items, compare.
4. **Hand-trace.** No execution access: take one concrete record's actual values and evaluate each implementation on paper, step by step, including rounding and null handling. Slower and error-prone — say in the report that confirmation was by trace, not execution.
5. **Stored vs recomputed.** For writer gaps (§3.1): recompute the derived value from current inputs and compare against the stored copy.

Rules: compare exact values (representation drift hides in rounding); pin both paths to the same data snapshot if data changes underneath; record the concrete example (entity, both values, both code paths) in the finding — a CRITICAL without a reproducible example is just a HIGH with confidence.

If reconciliation is infeasible, keep the structural severity, mark the finding **unconfirmed**, and give the user the exact query/command that would confirm it.

## §7 Baseline file format

`.claude/data-flow-baseline.md` in the project root. Two sections:

```markdown
# Data Flow Baseline
Last audit: {date} ({mode})

## Known rules
### {rule-name} ({N} conditions)
Canonical: {file:function}
Conditions: {field} = X; {field} IS NULL; ...
Locations: {file} (MATCH); {file} (MATCH); ...
Exceptions: {file} — {reason}

## Accepted findings
- {metric} — {pattern} — {severity} — accepted {date}: {one-line justification}
```

Add accepted findings only with explicit user sign-off. When a consolidation
fix lands, convert the finding into a known rule pointing at the new canonical
helper. Remove entries whose code no longer exists. Every audit starts by
validating this file (Step 0): a drifted known rule is a CRITICAL candidate, and
stale entries are pruned so the baseline stays trustworthy.
