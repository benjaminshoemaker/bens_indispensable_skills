# Codex Consultation Prompt Template

Template for the prompt sent to Codex CLI for document consultation.

## Structure

```markdown
# Pre-Consultation Research (REQUIRED)

Before reviewing the document, research the following:

{For each item in research_topics or auto-detected technologies}
- **{topic}**: Find current official documentation and best practices

{If project has CLAUDE.md, AGENTS.md, or similar}
- **Project standards**: Review any project documentation for conventions and requirements

# Document Under Review

**File:** `{file_path}`
**Type:** {document type — spec, plan, config, etc.}

{Full contents of the target file}

{If --upstream provided}
# Reference Document

This document should align with requirements from:
- **{upstream_file}**

Check that all key items are addressed and nothing important was lost or misrepresented.

Key items to verify:
{extracted requirements/decisions from upstream file}
{/If}

{If focus area provided}
# Focus Area

Pay special attention to: {focus_area}
{/If}

# Evaluation Criteria

Evaluate the document against these criteria:

1. **Completeness**: Are all necessary sections present? Are there gaps or missing details?
2. **Accuracy**: Are technical claims correct? Do recommendations match current best practices?
3. **Feasibility**: Are proposed approaches realistic and implementable?
4. **Consistency**: Are there internal contradictions or conflicting statements?
5. **Best Practices**: Does the document follow established patterns for its type?

{If upstream provided}
6. **Alignment**: Does this document faithfully represent requirements from the reference document?
{/If}

Provide specific section references for any issues found.

## Output Format

Provide findings in this exact format:

```
CONSULTATION FINDINGS
=====================
Document: {file_path}
Status: PASS | PASS_WITH_NOTES | NEEDS_ATTENTION

ISSUES (should be addressed)
-----------------------------
{List issues that should be addressed, or "None"}

Each issue format:
- [Section: {name}] Description
  -> Suggestion: How to improve

SUGGESTIONS (optional improvements)
------------------------------------
{List suggestions for improvement, or "None"}

POSITIVE FINDINGS
-----------------
{What was done well}

{If upstream context provided}
ALIGNMENT CHECK
---------------
- Items checked: {N}
- All addressed: Yes/No
- Missing/misrepresented: {list or "None"}
{/If}
```

Be specific. Reference section names. Prioritize by impact.
```

## Auto-Detection of Research Topics

When `--research` is not provided, auto-detect from:

1. **Document content** — Look for technology mentions:
   - Framework names (Next.js, React, Django, etc.)
   - Service names (Supabase, Stripe, AWS, etc.)
   - Protocol/pattern names (OAuth, REST, GraphQL, etc.)

2. **Project context** — If `package.json` or similar exists:
   - Check dependencies for relevant technologies
   - Note framework versions for documentation targeting

3. **Document type** — Suggest general topics:
   - Product spec → "product requirements, user stories"
   - Technical spec → "{detected technologies}"
   - Execution plan → "execution planning, task breakdown"

## Upstream Context Extraction

When `--upstream` is provided:

1. Read the upstream file
2. Extract numbered requirements, acceptance criteria, or key decisions
3. Include in prompt for Codex to verify against
4. Request explicit confirmation of each item in output
