# README Migration

How to migrate bloated README sections to docs/.

## Identify Migration Candidates

Look for these patterns in README:

```markdown
## Commands Reference
## Command Reference
## Commands
## CLI Reference
→ Migrate to: docs/commands.md

## File Structure
## Project Structure
## Directory Structure
→ Migrate to: docs/file-structure.md

## Configuration
## Config
## Settings
## Options
→ Migrate to: docs/configuration.md

## API Reference
## API
## Endpoints
→ Migrate to: docs/api.md
```

## Migration Process

For each section to migrate:

1. **Extract** the section content from README
2. **Create** the target docs/ file (if doesn't exist)
3. **Move** the content to docs/ file
4. **Replace** the README section with a link

### Before (README.md)

```markdown
## Commands Reference

| Command | Description |
|---------|-------------|
| /foo | Does foo |
| /bar | Does bar |
... (50 more rows)
```

### After (README.md)

```markdown
## Documentation

See [Commands Reference](docs/commands.md) for the full list of available commands.
```

### Created (docs/commands.md)

```markdown
# Commands Reference

| Command | Description |
|---------|-------------|
| /foo | Does foo |
| /bar | Does bar |
... (50 more rows)
```

## Ask Before Large Migrations

If migration would move > 100 lines:

```
README.md has a large "Commands Reference" section (156 lines).

Best practice: Move detailed reference content to docs/commands.md
and keep README as a concise landing page.

Migrate now?
[Y] Yes, migrate to docs/commands.md
[n] No, keep in README
[v] View content to migrate
```
