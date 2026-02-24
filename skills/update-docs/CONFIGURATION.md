# Documentation Sync Configuration

Projects can customize documentation sync behavior via `.claude/doc-sync-config.json`.

## Configuration Schema

```json
{
  "readme": {
    "maxLines": 300,
    "maxCommandsInTable": 10,
    "sectionsToMigrate": ["Commands", "Configuration", "API"]
  },
  "routing": {
    "commands": "docs/commands.md",
    "configuration": "docs/configuration.md",
    "api": "docs/api.md",
    "fileStructure": "docs/file-structure.md"
  },
  "changelog": {
    "enabled": true,
    "format": "keepachangelog"
  },
  "autoMigrate": false
}
```

## Options

### readme

| Option | Default | Description |
|--------|---------|-------------|
| `maxLines` | 300 | Warn when README exceeds this |
| `maxCommandsInTable` | 10 | Migrate if commands table exceeds this |
| `sectionsToMigrate` | `["Commands", "Configuration", "API"]` | Sections to move to docs/ |

### routing

Customize which docs/ file receives each content type.

### changelog

| Option | Default | Description |
|--------|---------|-------------|
| `enabled` | true | Whether to update CHANGELOG.md |
| `format` | `"keepachangelog"` | Format: `keepachangelog`, `conventional`, `simple` |

### autoMigrate

If `true`, migrations happen without asking. Default: `false`.
