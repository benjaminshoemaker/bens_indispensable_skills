# Detection Patterns

Reference document for detailed detection methodology used in Steps 2.5–6 of the data-flow-audit skill.

## Step 2.5: Detect Scattered Filter Predicates (Fingerprint Matching)

This step detects when the same business rule — defined by a cluster of filter conditions on the same column names — is implemented independently in multiple files and/or languages. This catches the "Active Spec Definition" class of problems that endpoint-centric analysis misses.

### 2.5.1 Extract filter predicates from scan scope

Scan all files in scope for filter operations and extract the column/field names used:

**SQL filters:**
```bash
# Find WHERE clauses and their column references in SQL
grep -rn "WHERE\|AND\|OR" supabase/migrations/ --include="*.sql" | grep -v "^--"
```

**Supabase client filters:**
```bash
# Find Supabase filter chains across all TS files
grep -rn "\.eq(\|\.is(\|\.not(\|\.or(\|\.filter(\|\.neq(\|\.isNot(" \
  src/pages/api/ src/lib/ trigger/jobs/ --include="*.ts" | grep -v test
```

**JavaScript/TypeScript filters:**
```bash
# Find JS filter predicates that reference field/column names
grep -rn "\.filter(" src/lib/ src/components/ --include="*.ts" --include="*.tsx" | grep -v test | grep -v node_modules
```

### 2.5.2 Build fingerprints per file

For each file that contains filter operations, record the set of column/field names used in filter contexts. A "fingerprint" is the set of field names a file filters on.

**Example fingerprints:**
```
active-specs.ts       → {spec_model, sold_date, not_for_sale, days_in_inv}
properties.ts         → {spec_model, sold_date, not_for_sale, days_in_inv}
snapshot-comps.ts     → {spec_model, sold_date, not_for_sale, days_in_inv}
compute_portfolio_performance() → {spec_model, sold_date, not_for_sale, days_in_inv}
```

### 2.5.3 Cluster matching

Find fingerprints that share 3+ field names across 3+ files. Each cluster is a candidate scattered business rule.

```bash
# For a candidate column cluster (e.g., active spec columns), find co-occurring files
grep -rl "spec_model" src/ trigger/ supabase/ --include="*.ts" --include="*.sql" | \
  while read f; do
    count=0
    grep -q "sold_date" "$f" && count=$((count+1))
    grep -q "not_for_sale" "$f" && count=$((count+1))
    grep -q "days_in_inv" "$f" && count=$((count+1))
    grep -q "spec_model" "$f" && count=$((count+1))
    [ $count -ge 3 ] && echo "$f ($count/4 fields)"
  done
```

**Discovery approach for unknown clusters:**
1. Collect all column names used in filter contexts across all files
2. Build a co-occurrence matrix: for each pair of columns, count how many files filter on both
3. Identify clusters of 3+ columns that co-occur in 3+ files — these are candidate business rules
4. Exclude common infrastructure patterns (e.g., `created_at`, `updated_at`, `id` filtering)

### 2.5.4 Validate candidates

For each candidate cluster, read each file to confirm it's implementing a filter (not just referencing the field in a SELECT, type definition, or comment). Eliminate false positives:
- **Type definitions** — referencing field names in interfaces/types (not a filter)
- **SELECT lists** — querying the column without filtering on it (not a scattered rule)
- **Comments/docs** — mentioning the column name in documentation
- **Test mocks** — test data that includes the field (symptom, not cause — captured in Step 6)

### 2.5.5 Assess severity

For each validated cluster:

| Condition | Severity |
|-----------|----------|
| 6+ locations across 2+ languages (SQL + TS), no canonical helper | CRITICAL |
| 6+ locations, canonical helper exists but >50% of locations bypass it | CRITICAL |
| 3-5 locations across 2+ languages | HIGH |
| Canonical helper exists but some consumers bypass it | HIGH |
| 2-3 locations in same language, or bypass is documented | MEDIUM |

### 2.5.6 Report scattered predicates

```
SCATTERED FILTER PREDICATES
----------------------------
Cluster: {descriptive name} ({N} conditions)
  Conditions: {col1} = X, {col2} IS NULL, {col3} IS NOT NULL, ...
  Canonical helper: {function name} | NONE
  Locations ({N} total, {M} languages):
    SQL:
      - {migration_file}:{function_name} — {N}/{total} conditions ({MATCH | PARTIAL | DRIFTED})
    TypeScript (Supabase client):
      - {file}:{line_range} — {N}/{total} conditions ({MATCH | PARTIAL | DRIFTED})
    TypeScript (JS filter):
      - {file}:{line_range} — {N}/{total} conditions ({MATCH | PARTIAL | DRIFTED})
    Trigger.dev:
      - {file}:{line_range} — {N}/{total} conditions ({MATCH | PARTIAL | DRIFTED})
  Bypass rate: {bypassing_count}/{total_count} ({percentage}%)
  Severity: {severity}
  Risk: Adding or changing a condition requires updating {N} locations across {M} languages
  Recommendation: {Extract canonical helper | Increase adoption of existing helper | Document intentional divergence}
```

---

## Step 3: Detect Duplicated Types and Helpers

### 3.1 Type duplication across routes

Look for type definitions in API route files that have overlapping field names:

```bash
# Find all type definitions in API routes and jobs
grep -rn "^type " src/pages/api/ trigger/jobs/ --include="*.ts" | grep -v test
```

Compare field names across types in different route files. Flag when:
- Two types in different files share >60% of their field names
- Both represent the same business entity (e.g., community metrics)

**Severity: HIGH** — types should live in a shared module, not be redefined per-route.

### 3.2 Helper function duplication

Look for utility functions defined locally in API route files and jobs:

```bash
# Find function definitions in API routes and jobs
grep -rn "^function \|^const .* = (" src/pages/api/ trigger/jobs/ --include="*.ts" | grep -v test
```

Flag when the same function name (or a function with the same signature) appears in multiple route files. Common culprits:
- `parseNumeric()` / `toNumber()` — numeric parsing
- `unwrapResult()` / `handleError()` — error unwrapping
- `transformRow()` / `formatRow()` — row transformation
- Date/month name formatting helpers

**Severity: HIGH** — these should be extracted to `src/lib/` modules.

### 3.3 Inline vs. shared computation

Check whether routes import computation from `src/lib/` or reimplement it inline:

```bash
# Good: importing from shared modules
grep -rn "from '.*lib/" src/pages/api/ trigger/jobs/ --include="*.ts" | grep -v test

# Suspicious: functions defined locally in route files
grep -c "^function " src/pages/api/**/*.ts
```

A route file with many locally-defined functions (>3) is a candidate for extraction.

### 3.4 Detect shared library bypass

A shared service module may exist (e.g., `src/lib/compService.ts`) but some route files query the same tables directly instead of importing from it. This is "library drift" — the shared module evolves, but the bypassing route doesn't get the updates.

**Detection method for TypeScript:**
1. For each `src/lib/*Service.ts` or `src/lib/*Helpers.ts` module, record which tables and RPCs it wraps
2. Scan API route files and Trigger.dev jobs for direct `.from()` or `.rpc()` calls to those same tables/RPCs
3. Flag any route or job that queries a table or RPC already encapsulated by a shared module without importing from that module

```bash
# Example: Find which tables compService.ts wraps
grep "\.from(\|\.rpc(" src/lib/compService.ts

# Then find routes/jobs that query those same tables directly
grep -rn "\.from('staging_qmi_report')" src/pages/api/ trigger/jobs/ --include="*.ts" | grep -v test
```

**Detection method for SQL:**
1. Find canonical SQL helper functions (shared definitions that encapsulate business rules)
2. Find other SQL functions that inline the same conditions instead of calling the helper

```bash
# Find SQL helper functions (canonical definitions)
grep -rn "CREATE.*FUNCTION" supabase/migrations/ --include="*.sql" | grep -i "active_spec\|get_community"

# Find SQL functions that inline the same conditions instead of calling the helper
grep -rn "spec_model.*=.*'Spec'" supabase/migrations/ --include="*.sql"
```

Flag when a SQL function inlines filter conditions that a shared SQL helper already encapsulates. This is the SQL equivalent of TypeScript library bypass.

**Severity: HIGH** — the route/job/SQL function is reimplementing logic that the shared module already provides.

**Note:** Sometimes the bypass is intentional (e.g., the route needs a different subset of columns, or a SQL function needs different JOIN context). Record these as MEDIUM and note the justification.

---

## Step 4: Detect Cross-Layer Formula and Constant Divergence

### 4.1 Find repeated magic numbers and strings

Look for business constants that appear in multiple files:

```bash
# Rates, thresholds, budget years
grep -rn "0\.12\|0\.025\|850\|2026\|BUDGET_YEAR\|PACE_BUDGET" src/ --include="*.ts" | grep -v test | grep -v node_modules

# Same constants in SQL
grep -rn "0\.12\|0\.025\|850\|2026" supabase/migrations/ --include="*.sql"
```

Flag when the same business constant appears in:
- Multiple API routes
- Both SQL and JS/TS layers
- Both a shared module and an inline usage

### 4.2 Check SQL ↔ JS consistency

For any computation that exists in both SQL functions and JS/TS code, verify the formulas match. Common divergence points:
- Carry cost rates
- Aging thresholds (e.g., >60 days)
- Rounding behavior
- Null handling

**Severity: CRITICAL** if a business formula appears in SQL and JS with different values.
**Severity: HIGH** if the same constant is hardcoded in multiple places without a shared definition.

### 4.3 Detect cross-layer formula duplication

Business formulas often need to exist in multiple layers (SQL for server-side aggregation, JS/TS for client-side interactivity). When the same formula is maintained independently in two or more layers, any update must touch all of them — and often doesn't.

**Detection method:**
1. Identify business computations in SQL migration files (carry cost, scoring, thresholds, rates)
2. Search for the same computation in `src/lib/` modules, API routes, Trigger.dev jobs, and frontend components
3. For each formula found in multiple layers, verify numerical consistency

**Common cross-layer splits:**
- **SQL + API route** — SQL function computes a metric, API route reimplements the same formula in JS for a different context
- **SQL + frontend** — SQL computes a default, frontend recomputes for "what-if" scenarios using its own constants
- **API route + frontend** — Server returns raw data, two different frontend components independently derive the same metric from it
- **SQL + Trigger.dev job** — Job reimplements a computation that a SQL function already provides

```bash
# Find formulas in SQL
grep -rn "0\.12\|0\.025\|/ 365\|/ 30\|* 30" supabase/migrations/ --include="*.sql"

# Find the same formulas in TS (including jobs)
grep -rn "0\.12\|0\.025\|/ 365\|/ 30\|ANNUAL_RATE\|MONTHLY" src/ trigger/ --include="*.ts" | grep -v test | grep -v node_modules
```

**Severity: CRITICAL** if formulas produce different numerical results across layers.
**Severity: HIGH** if formulas match today but are independently maintained without a documented link between them.

---

## Step 5: Map Frontend Consumers

### 5.1 Find all fetch calls

```bash
# Find API calls in frontend components
grep -rn "fetch(" src/components/ --include="*.tsx" --include="*.ts" | grep "/api/"
grep -rn "useSWR\|useQuery" src/components/ --include="*.tsx" --include="*.ts"
```

### 5.2 Build consumer map

For each API route, record which frontend components consume it:

```
Consumer Map:
| Route | Component(s) | UI Location |
|-------|-------------- |-------------|
```

### 5.3 Detect conflicting consumption

Flag when:
- **Same page, different endpoints** — Two components on the same page fetch overlapping data from different endpoints (highest risk for visible inconsistency)
- **Same data, different views** — A list view and a detail view fetch the same business metrics from different endpoints, risking values that don't match when a user navigates between them
- **Missing callback pattern** — A parent and child component independently fetch related data instead of the parent fetching once and passing data down via props/callbacks

**Severity: CRITICAL** if two components on the same page show the same metric from different sources.
**Severity: HIGH** if list and detail views compute the same metric differently.

---

## Step 6: Detect Test Mock Divergence

Test files are an early-warning system for split data sources. When two test files mock the same business data with different shapes, field names, or wrapper structures, it reveals that the code under test models the same concept differently.

### 6.1 Find test files for route groups

For each route group identified in Step 1, collect their test files:

```bash
# Find test files for community metrics endpoints
find src/pages/api/communities -name "*.test.*"
find src/components/communities -name "*.test.*"
find trigger/jobs -name "*.test.*" 2>/dev/null
```

### 6.2 Compare mock data shapes

Within each route group's test files, look for:

**Type shape divergence** — The same business entity mocked with different field names or structures:
```
# Test A mocks carry cost as a direct field
{ carryCost: 15000 }

# Test B mocks it through an RPC wrapper
{ data: [{ carry_cost: "15000" }] }
```

**Value representation divergence** — The same field represented differently:
- `number` vs `string` (e.g., `15000` vs `"15000"`)
- `snake_case` vs `camelCase` (e.g., `carry_cost` vs `carryCost`)
- Different null representations (`null` vs `0` vs `undefined` vs omitted)

**Mock endpoint divergence** — Test files that mock different URLs but expect the same data:
```bash
# Find all mocked fetch URLs in test files
grep -rn "fetch.*mock\|mockResolvedValue\|if.*input.*==.*'/api" src/ --include="*.test.*"
```

### 6.3 Evaluate divergence

Flag when:
- Two test files in the same route group mock the same business entity with >2 field-name differences
- The same metric uses different types (`number` vs `string`) across test mocks
- Response wrapper shapes differ (array vs single object, nested vs flat)

**Severity: MEDIUM** — Test mock divergence is a *symptom* of the underlying split, not the cause. It's useful as a fast early-warning signal before running the full data flow trace.

**Tip:** This step can be run as a lightweight pre-check. If mock shapes diverge, proceed with the full audit. If they're consistent, the risk of active divergence is lower.
