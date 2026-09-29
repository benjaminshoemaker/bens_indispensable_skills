---
name: innovate
description: Identify high-impact innovative additions to the current app or plan. Use when planning next features, during strategic reviews, or when the user asks for creative ideas.
allowed-tools: Read, Glob, Grep, Bash, WebSearch, WebFetch
---

# Innovate

Identify the **single highest-impact, feasible addition** to make to the current app or plan. Not a list of 10 safe ideas -- one bold, high-leverage move backed by deep product understanding. Reason from the product's own context first; external research is supplementary, not primary.

Copy this checklist and track progress:

```text
Innovation progress:
- [ ] Understand the project and user-facing product
- [ ] Read relevant plans and optionally assess the landscape
- [ ] Generate and score 5-7 candidates internally
- [ ] Select one winner and identify 2-3 runners-up
- [ ] Review the recommendation against all six criteria
```

## Context Gathering

Before proposing anything, deeply understand the current state:

### 1. Read the Project

```
Read: README.md, CLAUDE.md, AGENTS.md
Glob: src/**/*.{ts,tsx,js,jsx,py,go,rs,swift}
Grep: "TODO|FIXME|HACK|FUTURE"
```

Understand:
- What the project does and who it's for
- Current architecture and tech stack
- Existing features and capabilities
- Known gaps, tracked work, and pain points

### 2. Deeply Explore the Product Surface

Go beyond reading config files. Understand the full user-facing product:

- Walk the app's routes/screens to understand every user flow
- Read the data model (migrations, schemas) to see what data exists and how it connects
- Check feature directories, planning docs, deferred/next-steps files for the full picture
- Understand what the product *does today* from a user's perspective, not just what files exist

This deep exploration is what separates a good recommendation from a generic one. You cannot propose the right addition without understanding the product as a user would experience it.

### 3. Read Any Specs or Plans

```
Read: PRODUCT_SPEC.md, TECHNICAL_SPEC.md, EXECUTION_PLAN.md, FEATURE_SPEC.md, VISION.md
```

Understand where the project is headed and what's already planned.

### 4. Optionally Assess the Landscape

If the product domain is unfamiliar or you want to validate an emerging idea,
use WebSearch to research competitors, emerging technologies, or user
expectations. This step is supplementary — the strongest recommendations come
from reasoning about THIS product's specific context, not from surveying what
competitors do. Do not let external research override a conviction formed from
deep product understanding.

---

## Innovation Criteria

The proposal must score HIGH on ALL of these:

| Criterion | Question |
|-----------|----------|
| **Leverage** | Does a small implementation unlock disproportionate value? |
| **Surprise** | Would this make a user of THIS product say "I didn't know it could do that"? (Contextual novelty, not absolute novelty — a well-known technique applied in a new context counts.) |
| **Feasibility** | Can this be built in weeks, not quarters? |
| **Fit** | Does it align with the project's direction and users? |
| **Defensibility** | Is this hard to copy or does it create a moat? |
| **Compounding** | Does it create a flywheel — does usage make the product more valuable, which drives more usage? |

### Anti-Patterns (Do NOT Propose)

- Shallow AI bolt-ons that don't connect to the product's core data or value proposition (but DO consider deepening AI interaction in products whose core value IS AI — "add AI chat" is lazy for a todo app but may be exactly right for an AI-native product)
- Tiny incremental improvements with no compounding effect
- Features that require new infrastructure with no reuse of existing systems
- Ideas that sound cool but don't serve the actual users
- Features that duplicate planned work without meaningfully extending it (but DO consider ideas that deepen or combine planned directions in ways the individual plans don't anticipate)

---

## Analysis Process

### Step 1: Identify Latent Potential

Look for:
- **Underused data** — What data does the app collect that it doesn't fully exploit?
- **Workflow friction** — Where do users leave the app to accomplish something?
- **Combinatorial opportunities** — What existing features could be combined in unexpected ways?
- **Platform capabilities** — What OS/browser/runtime features could be leveraged?
- **Network effects** — What becomes more valuable as usage grows?

### Step 2: Generate Candidates (Internal)

Brainstorm 5-7 candidates internally. Evaluate each against the criteria table. When presenting the winner, briefly name 2-3 runners-up and why they lost — this lets the user redirect if your judgment call was wrong.

### Step 3: Select the Winner

Pick the single strongest candidate. If no candidate scores HIGH on all six
criteria, say so honestly rather than forcing a weak idea. Prefer the idea with
the strongest compounding/flywheel effect when multiple candidates score
similarly on other criteria — accretive value compounds in ways that one-time
features don't.

---

## Output Format

```
╔══════════════════════════════════════════════════════════════════╗
║                        THE INNOVATION                           ║
╚══════════════════════════════════════════════════════════════════╝

{One-sentence pitch — what it is and why it matters}

────────────────────────────────────────────────────────────────────

WHY THIS, WHY NOW
─────────────────
{2-3 sentences on why this is the right move at this moment.
Reference specific things discovered in context gathering.}

WHAT IT CHANGES
───────────────
Before: {Current state — what users deal with today}
After:  {Future state — what becomes possible}

HOW IT WORKS
────────────
{3-5 bullet points on the core mechanism. Be specific enough
that a developer could start building from this description.}

• ...
• ...
• ...

IMPLEMENTATION SKETCH
─────────────────────
Effort: {LOW / MEDIUM / HIGH}
Files:  {Key files to create or modify}
Dependencies: {New libraries or services needed, if any}

Steps:
1. {First concrete step}
2. {Second concrete step}
3. {Third concrete step}

RISK & MITIGATION
─────────────────
Risk: {The main thing that could go wrong}
Mitigation: {How to handle it}

────────────────────────────────────────────────────────────────────

CRITERIA SCORECARD
──────────────────
Leverage:      ██████████ HIGH — {one-line justification}
Surprise:      ██████████ HIGH — {one-line justification}
Feasibility:   ██████████ HIGH — {one-line justification}
Fit:           ██████████ HIGH — {one-line justification}
Defensibility: ██████████ HIGH — {one-line justification}
Compounding:   ██████████ HIGH — {one-line justification}

RUNNERS-UP
──────────
• {Runner-up 1} — why it lost: {one sentence}
• {Runner-up 2} — why it lost: {one sentence}
```

---

## Edge Cases

| Situation | Action |
|-----------|--------|
| No README or project context | Ask the user to describe the project before proceeding |
| Project is too early stage (no code) | Focus innovation on architecture/approach rather than features |
| Project is a library/SDK (not an app) | Focus on DX innovations, API design, or ecosystem integrations |
| All ideas feel incremental | Be honest: "This project is well-optimized. Here's the best marginal gain I see:" and lower expectations |
| The argument is optional | If invoked with an argument (e.g., `/innovate payments`), constrain the search to that domain |

## Error Handling

| Situation | Action |
|-----------|--------|
| No product context is available | Stop and ask for the target project path or product docs |
| Existing plans are missing or contradictory | Report the conflict and ask which source should drive recommendations |
| No high-confidence idea emerges | Say no recommendation is strong enough yet and list the missing context |

## Review Your Output

Before presenting:
- [ ] Proposal is ONE idea, not a list
- [ ] Scores HIGH on all six criteria (or honestly notes where it doesn't)
- [ ] Implementation sketch is specific enough to act on
- [ ] Not something already planned or obvious
- [ ] Aligned with project direction
