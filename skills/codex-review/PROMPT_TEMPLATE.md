# Codex Review Prompt Template

Template for the prompt sent to Codex CLI.

## Structure

```markdown
# Pre-Review Research (REQUIRED)

Before reviewing the code, research the following documentation:

{For each item in research_topics or auto-detected technologies}
- **{topic}**: Find current official documentation and best practices

{If project has CLAUDE.md, AGENTS.md, or similar}
- **Project patterns**: Review coding standards from project documentation

# Review Context

Branch: `{branch_name}`
Base: `{base_branch}`
Commits: {commit_count} commits

## Commits on this branch:
{commit_list from git log}

## Changed Files:
{file_list from git diff --stat}

{If --upstream provided}
# Upstream Context

This code should preserve requirements from:
- {upstream_file}

Check that nothing important was lost or incorrectly implemented.

Key requirements to verify:
{extracted requirements from upstream file}
{/If}

{If focus area provided}
# Focus Area

Pay special attention to: {focus_area}
{/If}

# Review Instructions

Provide a thorough code review covering:

1. **Correctness**: Logic errors, edge cases, potential bugs
2. **Best Practices**: Does the code follow established patterns?
3. **Consistency**: Are changes applied consistently across files?
4. **Documentation**: Are changes well-documented where needed?
5. **Potential Issues**: Security, performance, maintainability concerns

Use `git diff {base_branch}...HEAD` to see the full changes.

Provide specific file:line references for any issues found.

## Output Format

Provide findings in this exact format:

```
REVIEW FINDINGS
===============
Branch: {branch}
Status: PASS | PASS_WITH_NOTES | NEEDS_ATTENTION

CRITICAL ISSUES (blocking)
--------------------------
{List issues that must be addressed, or "None"}

Each issue format:
- [file:line] Description
  → Suggestion: How to fix

RECOMMENDATIONS (non-blocking)
------------------------------
{List suggestions for improvement, or "None"}

POSITIVE FINDINGS
-----------------
{What was done well}

{If upstream context provided}
CONTEXT PRESERVATION
--------------------
- Requirements checked: {N}
- All preserved: Yes/No
- Missing/incorrect: {list or "None"}
{/If}
```

Be specific. Reference line numbers. Prioritize by impact.
```

## Auto-Detection of Research Topics

When `--research` is not provided, auto-detect from:

1. **package.json** — Look for key dependencies:
   - `next` → "Next.js App Router"
   - `@supabase/supabase-js` → "Supabase"
   - `stripe` → "Stripe API"
   - `@auth/core` → "Auth.js"

2. **Changed files** — Check imports:
   - React hooks → "React Hooks"
   - API routes → "Next.js API Routes"
   - Database queries → relevant ORM docs

3. **File types** — Suggest based on extensions:
   - `.prisma` → "Prisma ORM"
   - `.graphql` → "GraphQL"

## Upstream Context Extraction

When `--upstream` is provided:

1. Read the upstream file
2. Extract numbered requirements, acceptance criteria, or key decisions
3. Include in prompt for Codex to verify against
4. Request explicit confirmation of each item in output
