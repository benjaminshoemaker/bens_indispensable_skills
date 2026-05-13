# Compatibility

This table summarizes what each skill needs in order to work well.

| Skill | Requires | Optional Context | Notes |
|-------|----------|------------------|-------|
| `audit-skills` | A repo with `skills/*/SKILL.md` or `.claude/skills/*/SKILL.md` | `.claude/commands/*.md` | Best for skill and prompt repositories. |
| `capture-session` | Write access to the repo | `LEARNINGS.md`, `CLAUDE.md`, `AGENTS.md` | Creates or updates `LEARNINGS.md`; future agents need instructions to read it. |
| `capture-work` | Write access to the repo | `BUGS.md`, `NEXT_STEPS.md`, `DEFERRED.md`, `features/` | Creates lightweight work-tracking files when missing. |
| `codex-consult` | Codex CLI and `codex login` | `.claude/settings.local.json` | Reviews docs, specs, and plans with Codex. |
| `codex-implement` | Codex CLI and `codex login` | `AGENTS.md`, `CLAUDE.md`, verification commands | Highest-risk Codex skill because it asks Codex to edit files. |
| `codex-review` | Codex CLI, `codex login`, and a git repo | `.claude/settings.local.json`, upstream docs | Reviews code changes or branches. |
| `data-flow-audit` | Source files to inspect | API routes, SQL migrations, jobs, frontend consumers | Works best in apps with APIs, database queries, or duplicated business rules. |
| `discover-flow-verification` | A concrete flow claim to analyze | Product docs, test setup, provider sandbox details | Produces a verification-harness plan; does not implement it by itself. |
| `innovate` | Product or repo context | Web access, specs, plans, README | Research-backed product strategy; web access improves output. |
| `search-chats` | Local Claude Code or Codex CLI session logs | Project filter, agent filter | Searches `~/.claude/projects` and `~/.codex/sessions`; not useful without local logs. |
| `triage` | Work-tracking files or issues to inspect | Product docs, plans, feature specs | Organizes work; asks before implementation. |
| `ui-ux` | UI code or product context | Web access, design tokens, component library | Works as an audit or design-planning skill. |
| `update-docs` | A git repo or documentation files | `.claude/doc-update-pending.json`, docs config | Can update README, AGENTS.md, CHANGELOG, and docs. |
| `work-status` | Work-tracking files or feature docs | `plans/PLAN_STATUS.md`, `features/`, archive files | Read-only summary of current and possible work. |

## Common Skill Directories

Different agents look for skills in different places. Common local destinations:

- Claude Code: `~/.claude/skills/`
- Agents-compatible runtimes: `~/.agents/skills/`
- Codex setups that read directly from Codex home: `~/.codex/skills/`

Use `./install.sh --dest <path>` to pick the target directory explicitly.
