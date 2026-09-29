# Installation Strategy

Use this repository as the only canonical source for Ben's reusable personal
skills. Agent home directories contain selected copies, not another source of
truth.

## Principles

- Keep one canonical implementation under `skills/` in this repository.
- Install copies so moving, archiving, or switching the checkout cannot break
  an agent's global skill inventory.
- Use one destination per agent. Do not duplicate the same skill through
  `~/.agents/skills` and an agent-specific directory.
- Select skills by actual usage. A skill being available here does not make it
  part of a mandatory workflow.
- Use symlinks only while actively developing a skill and replace them with
  copies when the change is complete.

## Recommended Codex Profile

Codex does not need the three `codex-*` cross-model skills. Install the general
research, design, verification, review, and strategy capabilities directly:

```bash
./install.sh --method copy --force --dest ~/.codex/skills \
  --skill project-research \
  --skill design-directions \
  --skill discover-flow-verification \
  --skill data-flow-audit \
  --skill innovate \
  --skill search-chats \
  --skill security-scan \
  --skill tone-check \
  --skill ui-ux \
  --skill audit-skills
```

## Recommended Claude Code Profile

Claude Code can use the same general skills plus the three skills that bring in
Codex as a second model:

```bash
./install.sh --method copy --force --dest ~/.claude/skills \
  --all
```

`--all` is appropriate here only because this repository is already the curated
Claude Code collection. Reconsider that choice whenever the catalog grows.

## Updating Installed Copies

Pull or update this repository, review the changed skills, run the relevant
skill audits and tests, then repeat the installation command with `--force`.
The install is intentionally explicit; it does not silently update agent homes.

## Removing A Skill

Remove the installed copy from the relevant agent directory. Do not delete the
canonical skill from this repository merely because one agent should stop
loading it. Before broad cleanup, move old installations to a dated backup or
the operating system Trash so project-specific skills can be recovered.

## Invocation Model

- Let narrow skill descriptions trigger skills when the current task actually
  matches.
- Invoke a skill explicitly when you want to force that mode of work.
- `project-research` is for meaningful uncertainty, not every new task.
- `design-directions` is for unsettled visual language, not routine UI edits.
- Planning remains lightweight and situational; this catalog does not recreate
  a staged project lifecycle.
