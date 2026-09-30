# Command: add-vscode-config

**Entry point:** `lib/src/commands/add_vscode_config.dart` → `addVscodeConfig()`
**Runner:** `AddVscodeConfigCommand`. Also called by `init`.

## Usage

```bash
clean-helper add-vscode-config
```

## Output

| File | Helper → template |
|---|---|
| `.vscode/extensions.json` | `generateVscodeExtensions()` → `vscode_extensions` |
| `.vscode/launch.json` | `generateVscodeLaunch()` → `vscode_launch` |
| `.vscode/tasks.json` | `generateVscodeTasks()` → `vscode_tasks` |

All three use `writeFile`, so existing files are kept. To regenerate one, delete it first.
