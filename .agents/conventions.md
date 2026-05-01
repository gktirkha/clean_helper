# Code Conventions

## One Function Definition Per File

Every `.dart` file under `lib/src/` contains exactly **one** public function definition.
A file may import and call other functions freely, but must never define additional ones.

```
✅ correct — imports and calls other functions
void generateCoreFiles(String packageName) {
  writeFile(...);              // imported from shared/write_file.dart
  overwriteFile(...);          // imported from shared/write_file.dart
  analysisOptionsTemplate();   // imported from templates/
}

❌ wrong — two definitions in one file
void generateCoreFiles(...) { ... }
void generateNetworkFiles(...) { ... }  // must be a separate file
```

---

## Command Files

Files in `lib/src/commands/` contain **exactly one function** — the command entry point.
All logic lives in `lib/src/functions/`.

---

## Templates

All generated file content lives in `lib/src/templates/` — one function per file, returning `String`.
Generator functions must **never** contain inline template strings.

```
✅ correct
void generateFeaturePage(String feature, String basePath) {
  final className = pascalCase(feature);
  writeFile('$basePath/...', featurePageTemplate(feature, className));
}

❌ wrong — inline string in generator
void generateFeaturePage(...) {
  writeFile('$basePath/...', '''
  import 'package:flutter/material.dart';
  ...
  ''');
}
```

Template functions are imported using `../../templates/<file>.dart` from within `lib/src/functions/*/`.

---

## writeFile vs overwriteFile

Both are exported from `lib/src/functions/shared/write_file.dart`.
Both automatically create parent directories — never call `Directory.createSync` before them.

| Function | Behaviour | When to use |
|----------|-----------|-------------|
| `writeFile(path, content)` | Skips if file already exists, logs skip | User-editable files — never stomp on their work |
| `overwriteFile(path, content)` | Always writes, logs the write | Tool-owned generated files (e.g. `analysis_options.yaml`, `app_router_module.dart`) |

---

## String Case Helpers

All in `lib/src/functions/shared/`:

| File | Function | Input → Output |
|------|----------|----------------|
| `pascal_case.dart` | `pascalCase(input)` | `my_feature` → `MyFeature` |
| `camel_case.dart` | `camelCase(input)` | `my_feature` → `myFeature` |
| `kebab_case.dart` | `kebabCase(input)` | `my_feature` → `my-feature` |

---

## ensurePubspec & abort

Every command starts with `ensurePubspec()`.
It calls `abort(message)` if `pubspec.yaml` is not found in the current directory.
`abort()` has return type `Never` — it prints to stderr and calls `exit(1)`.

After the pubspec check, `ensurePubspec()` calls `resolveMonoRepoProject()` (from `shared/resolve_mono_repo_project.dart`). This function:
- Returns immediately if `lib/` exists (normal single-project).
- Reads `clean-helper.mono_repo_apps` from pubspec if `lib/` is absent.
  - If found: prompts the user to select a project, then sets `Directory.current` to the chosen app path.
  - If not found: calls `abort()` with instructions to declare the apps.

All subsequent file operations use relative paths and therefore automatically target the selected project directory. **No command needs any monorepo-specific logic.**

---

## Monorepo pubspec declaration

Users declare a monorepo by adding this section to the root `pubspec.yaml`:

```yaml
clean-helper:
  mono_repo_apps:
    - apps/app1
    - apps/app2
```

Parsed by `readMonoRepoApps()` in `lib/src/functions/shared/read_mono_repo_apps.dart`.

---

## `--scope` global flag

`--scope=<app_name>` is a global option declared on `CleanHelperRunner.argParser`. It is extracted in `CleanHelperRunner.runCommand()` and stored in the `resolveScope` variable (`lib/src/functions/shared/scope_option.dart`) before any subcommand runs. `resolveMonoRepoProject()` reads it to skip or narrow the interactive prompt. No command or helper file needs to handle it directly.

---

## All Paths Are Relative to the Target Flutter Project

This tool is run **from inside a Flutter project root**, not from inside `clean_helper/`.
All file paths in `writeFile`, `overwriteFile`, `Directory.createSync`, etc. are relative to the user's project CWD.

---

## Import Paths

- Shared utilities: `../shared/<file>.dart`
- Templates: `../../templates/<file>.dart` (from within `lib/src/functions/*/`)
- Init helpers: relative sibling imports within `init/`
- Feature/repo/entity helpers: relative sibling imports within their folder
