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

## Recommended Profile for Claude Code and Codex

Use the same curated set of 15 skills in both clients, including the three
`codex-*` skills and the two prompt skills. The three Codex workflows keep their
skip-when-inside-Codex guards; installing the same set does not change that behavior.

```bash
./install.sh --method copy --force --dest ~/.codex/skills --all
./install.sh --method copy --force --dest ~/.claude/skills --all
```

`--all` selects the current curated catalog. Review additions before repeating
these commands when the catalog grows.

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
