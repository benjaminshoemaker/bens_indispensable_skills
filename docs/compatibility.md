# Compatibility

This table summarizes what each skill needs in order to work well.

| Skill | Requires | Optional Context | Notes |
|-------|----------|------------------|-------|
| `audit-skills` | A repo with `skills/*/SKILL.md` or `.claude/skills/*/SKILL.md` | `.claude/commands/*.md` | Best for skill and prompt repositories. |
| `codex-consult` | Codex CLI and `codex login` | `.claude/settings.local.json` | Reviews docs, specs, and plans with Codex. |
| `codex-implement` | Codex CLI and `codex login` | `AGENTS.md`, `CLAUDE.md`, verification commands | Highest-risk Codex skill because it asks Codex to edit files. |
| `codex-review` | Codex CLI, `codex login`, and a git repo | `.claude/settings.local.json`, upstream docs | Reviews code changes or branches. |
| `data-flow-audit` | Source files to inspect | API routes, SQL migrations, jobs, frontend consumers | Works best in apps with APIs, database queries, or duplicated business rules. |
| `design-directions` | Product context or an existing interface to explore | Browser or image rendering, design references, existing tokens | Produces comparable visual alternatives; visual verification is needed before convergence. |
| `discover-flow-verification` | A concrete flow claim to analyze | Product docs, test setup, provider sandbox details | Produces a verification-harness plan; does not implement it by itself. |
| `innovate` | Product or repo context | Web access, specs, plans, README | Selects one recommendation, shows runners-up, and favors compounding value. |
| `project-research` | A domain, thesis, opportunity comparison, or early product question | Web access, repository context, prior research | Tracks falsification and changing hypotheses; reconciles durable context only when it will remain useful. |
| `search-chats` | Local Claude Code or Codex CLI session logs | Project filter, agent filter | Searches `~/.claude/projects` and `~/.codex/sessions`; not useful without local logs. |
| `security-scan` | A repository to inspect | Project-native dependency and static-analysis commands | Does not install missing scanners or apply fixes automatically. |
| `tone-check` | A document to inspect | At least five reliable user-authored session samples | Reports marker analysis without a voice-match score when samples are insufficient. |
| `ui-ux` | UI code or product context | Web access, design tokens, component library | Works as an audit or design-planning skill. |

## Common Skill Directories

Different agents look for skills in different places. Prefer one destination
per agent so the same skill is not discovered twice:

- Claude Code: `~/.claude/skills/`
- Codex setups that read directly from Codex home: `~/.codex/skills/`
- Agents-compatible runtimes without a dedicated home: `~/.agents/skills/`

Use `./install.sh --dest <path>` to pick the target directory explicitly. See
the [Installation Strategy](installation-strategy.md) before populating a shared
agents directory alongside an agent-specific one.
