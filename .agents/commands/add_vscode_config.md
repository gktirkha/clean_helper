# Command: add_vscode_config

**Entry point:** `lib/src/commands/add_vscode_config.dart` → `addVscodeConfig()`
**Runner Command:** `AddVscodeConfigCommand`

---

## Usage

```bash
clean-helper add_vscode_config
```

No arguments. Must be run from a Flutter project root.
Idempotent — existing files are skipped (`writeFile` is used for all three outputs).

---

## What It Generates

| File | Purpose |
|------|---------|
| `.vscode/extensions.json` | Recommended VS Code extensions for the project |
| `.vscode/launch.json` | Debug launch configurations |
| `.vscode/tasks.json` | Common project tasks (e.g. build_runner, flutter run) |

All three files are written with `writeFile` — they are skipped silently if they already exist.

---

## Implementation

Generator helpers live in `lib/src/functions/vscode_config/`:
- `generate_vscode_extensions.dart` → `generateVscodeExtensions()`
- `generate_vscode_launch.dart` → `generateVscodeLaunch()`
- `generate_vscode_tasks.dart` → `generateVscodeTasks()`

---

## Notes

- `addVscodeConfig()` is also called automatically as part of `runInit()` — no need to run it separately after `init`.
- To regenerate these files after `init`, run with the files deleted first (or use a text editor directly — these files are intentionally user-editable).
