# Interactive Q&A Workflow

After displaying the prioritized list and summary, offer the user an interactive session to clarify requirements.

**IMPORTANT:** Every question to the user in this workflow MUST use the `AskUserQuestion` tool. Never ask questions via plain text output.

## Step 1: Choose Action

Use the AskUserQuestion tool to ask:

If any items in TODOS.md currently have the `[ready]` tag (and are not completed),
include the "Un-ready an item" option. Otherwise, show only "Clarify" and "I'm done".

```
Question: "What would you like to do next?"
Header: "Q&A Mode"
Options:
  - Label: "Clarify an item"
    Description: "Ask questions about a specific item to improve its requirements"
  - Label: "Un-ready an item"                          # Only show if [ready] items exist
    Description: "Remove [ready] tag from an item whose requirements have changed"
  - Label: "I'm done"
    Description: "Exit without further changes"
```

- **"Clarify an item"** → proceed to Step 2 (Select Item to Clarify)
- **"Un-ready an item"** → proceed to Step 1b (Remove Ready Tag)
- **"I'm done"** → go to Exit Summary

After completing a clarification or un-ready round, return to this Step 1 prompt.

### Step 1b: Remove Ready Tag

Show only items that currently have the `[ready]` tag (and are not completed):

```
Question: "Which item should have its [ready] tag removed?"
Header: "Un-ready"
Options:
  - Label: "1. {ready item 1 title}"
    Description: "Currently tagged [ready]"
  - Label: "2. {ready item 2 title}"
    Description: "Currently tagged [ready]"
  ... (up to 4 items)
```

After the user selects an item:

1. Use the Edit tool to remove the `[ready]` tag from that item in TODOS.md
2. Output confirmation:
   ```
   Removed [ready] tag from: {item title}
   This item will no longer be picked up by /run-todos.
   ```
3. Return to Step 1

## Step 2: Select Item to Clarify

Use AskUserQuestion to let them pick an item:

```
Question: "Which item would you like to clarify? (Enter the priority number)"
Header: "Select Item"
Options:
  - Label: "1. {first item title}"
    Description: "Score: {N}/10 — {next action}"
  - Label: "2. {second item title}"
    Description: "Score: {N}/10 — {next action}"
  - Label: "3. {third item title}"
    Description: "Score: {N}/10 — {next action}"
  - Label: "4. {fourth item title}"
    Description: "Score: {N}/10 — {next action}"
```

Note: Only show up to 4 items per question (tool limit). If more items exist, include "Other" option for the user to type a number.

## Step 3: Summarize Current State

Before asking questions, output a summary of the selected item's current state so the user has context:

```markdown
---

## Clarifying: {Item Title}

**Current Score:** {N}/10 {multiplier if applicable}
**Requirements Clarity:** {Low|Medium|High}

**What's documented:**
{Summary of what's currently in TODOS.md for this item — existing description, any prior clarifications}

**What needs clarification:**
{List the open questions that will be asked}

---
```

This gives the user context before they start answering questions.

## Step 4: Ask Open Questions One at a Time

For the selected item, ask each open question individually using AskUserQuestion:

```
Question: "{The open question from the analysis}"
Header: "{Item title (truncated)}"
Options:
  - Label: "{Claude's recommended answer}"
    Description: "(Recommended) {Brief rationale for this recommendation}"
  - Label: "{Alternative answer 1}"
    Description: "{Why someone might choose this}"
  - Label: "{Alternative answer 2}"
    Description: "{Why someone might choose this}"
```

**Important guidelines for questions:**
- Ask ONE question at a time
- Always provide Claude's recommendation as the FIRST option with "(Recommended)" in the description
- Provide 2-3 reasonable alternatives as other options
- The user can always select "Other" to provide a custom answer
- Wait for each answer before asking the next question

## Step 5: Update TODOS.md with Clarifications

After all questions for an item are answered, update TODOS.md:

1. Find the item's section in TODOS.md
2. Add a new subsection or update the existing description with the clarifications
3. Format the clarifications clearly:

```markdown
### {Item Title}

{Original description}

**Clarifications (from Q&A {date}):**
- {Question 1}: {Answer 1}
- {Question 2}: {Answer 2}
- {Question 3}: {Answer 3}
```

Use the Edit tool to make these updates.

## Step 6: Summarize Understanding

After updating TODOS.md, output a summary of the clarified item:

```markdown
---

## Summary: {Item Title}

**Updated Score:** {N}/10 (re-evaluate based on new clarity)
**Requirements Clarity:** {Low|Medium|High} (updated)

**Current understanding:**
{2-4 sentences synthesizing what we now know about this item — the problem it solves, the approach, key decisions made}

**Implementation approach:**
{Brief description of how to implement, based on clarifications}

**Remaining questions (if any):**
- {Any questions still unanswered}

---
```

## Step 7: Check Implementation Readiness

**Guard: Validate that clarifications were actually captured.**

Before offering the readiness prompt, check whether any clarifications were recorded
for this item during *this* Q&A session (i.e., Step 4 was completed and Step 5 wrote
clarifications to TODOS.md).

- **If clarifications WERE captured** → show the readiness prompt normally.
- **If NO clarifications were captured** (user selected the item but skipped or
  had no questions answered) → show a warning first:

```
⚠ No clarifications were captured for this item during this session.
Marking as [ready] without clarification may lead to implementation
issues if requirements are unclear.
```

Then show the readiness prompt with a modified first option:

```
Question: "Is this item ready for implementation?"
Header: "Ready?"
Options:
  - Label: "Yes, mark as [ready] anyway"
    Description: "Requirements are already clear enough — no clarification needed"
  - Label: "No, needs more clarification"
    Description: "Continue Q&A on this item"
  - Label: "No, move to another item"
    Description: "Select a different item to clarify"
  - Label: "No, I'm done for now"
    Description: "Exit Q&A mode"
```

**If clarifications WERE captured**, use the standard prompt:

```
Question: "Is this item ready for implementation?"
Header: "Ready?"
Options:
  - Label: "Yes, mark as [ready]"
    Description: "Add [ready] tag to TODOS.md — item can be implemented"
  - Label: "No, needs more clarification"
    Description: "Continue Q&A on this item"
  - Label: "No, move to another item"
    Description: "Select a different item to clarify"
  - Label: "No, I'm done for now"
    Description: "Exit Q&A mode"
```

**If "Yes, mark as [ready]" (or "Yes, mark as [ready] anyway"):**
- Add `[ready]` tag to the TODO item in TODOS.md
- Return to Step 1 (unified action prompt)

**If "No, needs more clarification":**
- Ask what additional questions need answering
- Return to Step 4 with new questions

**If "No, move to another item":**
- Return to Step 2 to select another item

**If "No, I'm done for now":**
- Go to Exit Summary

## Exit Summary

When exiting Q&A mode, output:

```markdown
## Q&A Session Complete

**Items clarified:** {count}
{List of items that were clarified, with brief summary of decisions made}

TODOS.md has been updated with the changes above.
```
