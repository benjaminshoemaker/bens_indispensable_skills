# Audit Criteria

Check each skill against these criteria. Record violations with the criterion ID.

## Length & Structure

### L1: SKILL.md exceeds 500 lines
- **Severity**: High
- **Check**: `wc -l SKILL.md`
- **Why**: Context rot - accuracy degrades with length; agent works from memory
- **Fix**: Split into main overview + reference files (REFERENCE.md, WORKFLOW.md, etc.)

### L2: Monolithic structure (no progressive disclosure)
- **Severity**: Low
- **Check**: Skill >500 lines with no references to other .md files
- **Why**: Forces full context load; no selective reading
- **Fix**: Extract detailed sections into separate files, link from main SKILL.md

**Note**: Per [Anthropic best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices), "Keep SKILL.md under 500 lines. If approaching this limit, split content into reference files." Skills under 500 lines with clear section structure are acceptable.

### L3: Nested references (>1 level deep)
- **Severity**: Medium
- **Check**: Reference file links to another reference file
- **Why**: Agent may partially read with `head`, missing critical info
- **Fix**: Flatten - all references should link directly from SKILL.md

## Checklists & Verification

### C1: Multi-step workflow lacks checklist
- **Severity**: High
- **Check**: Has 3+ sequential steps but no checklist in a code block
- **Why**: Agent skips steps when working from memory on long workflows
- **Fix**: Add checklist per Anthropic's recommended format:

~~~markdown
Copy this checklist and track progress:

```
Task Progress:
- [ ] Step 1: First step
- [ ] Step 2: Second step
```
~~~

**Note**: Checklists belong INSIDE code blocks (not raw markdown). Claude copies the block into its response and checks items off as it works. This is Anthropic's recommended pattern for copyable checklists — see their [best practices docs](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices).

### C2: No verification after critical actions
- **Severity**: High
- **Check**: File operations, API calls, or state changes without subsequent verification
- **Why**: Silent failures; agent marks complete without confirming success
- **Fix**: Add verification command after critical steps (e.g., `ls` after copy, status check after API call)

### C3: No feedback loop for quality-critical tasks
- **Severity**: Medium
- **Check**: Output generation without validate/fix/retry pattern
- **Why**: First attempt errors persist to final output
- **Fix**: Add "validate → fix → repeat" loop

## Step Clarity

### S1: Unclear workflow structure
- **Severity**: Low
- **Check**: Sequential workflow where steps are hard to distinguish
- **Why**: Agent may not recognize discrete execution points
- **Fix**: Use any clear format: `### Step N:`, `**Step N:**`, or numbered lists (`1. First...`)

**Note**: Multiple formats are acceptable per Anthropic best practices. The key is clarity and consistency WITHIN a skill, not a specific format. Numbered lists, bold headers, and markdown headings all work.

### S2: Critical instructions not repeated
- **Severity**: Low
- **Check**: Important rules appear only once in long skill (>300 lines)
- **Why**: Models follow instructions near prompt end more strictly
- **Fix**: Repeat critical rules in REMINDER section at end

### S3: Ambiguous action vs. reference
- **Severity**: Medium
- **Check**: Script mentioned without clarity on execute vs. read
- **Why**: Agent may read code into context instead of running it
- **Fix**: Explicit: "Run `script.py`" (execute) vs. "See `script.py` for algorithm" (read)

## Error Handling

### E1: No error handling paths
- **Severity**: Medium
- **Check**: No "if X fails" or "if not found" guidance
- **Why**: Agent halts or guesses when encountering errors
- **Fix**: Add explicit recovery paths for likely failure modes

### E2: No "way out" for edge cases
- **Severity**: Low
- **Check**: No guidance for when task cannot be completed
- **Why**: Agent may hallucinate completion or loop indefinitely
- **Fix**: Add escape hatch: "If unable to complete, report reason and stop"

## Description Quality

### D1: Description missing "when to use"
- **Severity**: Medium
- **Check**: Description only says what skill does, not when to invoke it
- **Why**: Poor skill discovery/selection by agent
- **Fix**: Add trigger phrases: "Use when...", "Triggers on..."

### D2: Description uses first/second person
- **Severity**: Low
- **Check**: Description contains "I", "you", "we"
- **Why**: Inconsistent point-of-view confuses skill selection
- **Fix**: Use third person: "Analyzes..." not "I analyze..." or "You can use this to..."

### D3: Description too vague
- **Severity**: Medium
- **Check**: Generic terms like "helps with", "processes", "handles"
- **Why**: Doesn't differentiate from other skills
- **Fix**: Use specific terms: "Extracts text from PDF files" not "Processes documents"
