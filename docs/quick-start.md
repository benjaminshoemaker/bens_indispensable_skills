# Quick Start

This walkthrough shows one way the independent skills can support product and
feature work. It is not a required lifecycle.

## 1. Install The Skills

From this repo:

```bash
./install.sh --list
./install.sh --dest ~/.codex/skills \
  --skill project-research --skill design-directions
```

For a different agent directory:

```bash
./install.sh --dest ~/.claude/skills \
  --skill project-research --skill design-directions
```

Repeat `--skill` for any additional capabilities you want. Use `--all` only
when you intentionally want the full collection. Restart your agent after
installing.

## 2. Research A Project Direction

For an early product, feature, or design direction, ask:

```text
/project-research Explore whether a design-direction skill could help me create
more distinctive interfaces. Research existing approaches and help me form a
point of view before we decide what to build.
```

Expected result:

- The skill captures your starting experience and preferences.
- It preserves whether you are exploring, testing, comparing, or deciding
  instead of automatically pushing toward a product.
- It declares the unit of analysis and searches for the strongest
  counterexample or closest existing substitute.
- It inspects relevant project context and researches external evidence.
- It separates facts, inferences, hypotheses, falsifications, and decisions.
- It recommends whether to proceed, prototype, investigate further, preserve
  durable context, or create a bounded plan.

When visual direction is the next important uncertainty, continue with:

```text
/design-directions Use the project context to explore several genuinely
different visual languages on the same representative product screen.
```

Expected result:

- The alternatives differ in composition, typography, form, color, imagery,
  and behavior rather than functioning as palette swaps.
- Your reactions are translated into durable design principles.
- The selected direction is refined and visually verified before it becomes a
  broader design system.

## 3. Add Other Skills When Needed

The remaining examples require their named skills. Install them selectively as
they become useful rather than treating the walkthrough as a required sequence.

## 4. Delegate to a Separate Codex Session

From Claude Code, use a separate Codex CLI session for planning, review, and scoped implementation. These skills remain installed in Codex but skip there:

```text
/codex-consult FEATURE_SPEC.md
/codex-review
/codex-implement "Add the missing empty state using the existing component patterns"
```

Expected result:

- `codex-consult` gives a second opinion on docs, plans, and specs.
- `codex-review` checks the current diff or branch.
- `codex-implement` delegates a bounded implementation task to Codex CLI.

## 5. Define Flow Verification

Ask:

```text
/discover-flow-verification "A user can save a report filter and see it applied after reload"
```

Expected result:

- The skill identifies the exact flow claim.
- It recommends a repeatable harness shape.
- It names the command, browser/API actions, assertions, evidence, and teardown
  needed for agent-verifiable proof.

## 6. Use Milestone Skills

At larger milestones, ask:

```text
/ui-ux audit src/components
/innovate
/data-flow-audit
/security-scan
/tone-check path/to/draft.md
/search-chats "pricing CTA"
```

Expected result:

- `ui-ux` finds interface and design-system issues.
- `innovate` proposes one high-leverage product improvement.
- `data-flow-audit` finds duplicated business rules and split data sources.
- `security-scan` checks dependencies, secrets, and project-native analyzers.
- `tone-check` flags formulaic writing and personal-voice mismatches.
- `search-chats` recovers prior decisions from local agent sessions.
