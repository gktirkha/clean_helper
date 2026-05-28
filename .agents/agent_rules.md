# Rules for AI Agents

These constraints must be respected when modifying or extending this codebase.

---

## File Structure Rules

- **One function definition per file** — everywhere under `lib/src/`.
- **Command files have one function** — never add helpers directly in `lib/src/commands/`.
- **Never export function files** from `lib/clean_helper.dart` — commands only.
- **New helpers go in `lib/src/functions/<group>/`** — create a new file, never add to an existing one.
- **New templates go in `lib/src/templates/`** — one template function per file, returning `String`.
- **No inline template strings in generator functions** — all generated file content must live in `lib/src/templates/`.

---

## File Writing Rules

- Use `writeFile(path, content)` for files the user may edit — skips if file exists.
- Use `overwriteFile(path, content)` only for config files owned by the tool (e.g. `analysis_options.yaml`, `app_router_module.dart`).
- Never use `File(...).writeAsStringSync(...)` directly — always go through the shared helpers.
- `writeFile` and `overwriteFile` both call `file.parent.createSync(recursive: true)` — **never** manually create directories before writing.
- When a command supports optional overwrite (e.g. `generate_tools --overwrite`), select the write function via `final write = overwrite ? overwriteFile : writeFile` and use that variable throughout.

---

## Directory Creation Rules

- Never call `Directory(...).createSync(...)` outside of `lib/src/functions/init/create_directories.dart`.
- Directory creation for generated files is handled automatically by `writeFile`/`overwriteFile`.
- New directory paths needed during `init` must be added to the list in `create_directories.dart`.

---

## Path Rules

- All generated file paths are **relative to the Flutter project's CWD**, not to `clean_helper/`.
- Do not use `path.join` or absolute paths — keep paths as plain relative strings.

---

## Import Rules

- Shared utilities: import from `../shared/<file>.dart`.
- Templates: import from `../../templates/<file>.dart` (from within `lib/src/functions/*/`).
- Do not create circular imports between function files.
- `camel_case.dart` may import `pascal_case.dart` (it depends on it); nothing else may form a cycle.
- Generated Flutter project files must use **relative imports** for internal project files — no `package:` imports between files within the same feature.

---

## Naming Rules

- Function files: `snake_case.dart` matching the function name.
- Public functions: `camelCase`, matching the file name in camelCase.
- Template functions: suffix `Template` (e.g. `mainDartTemplate()`).
- Generator functions in `init/`: prefix `generate` or `create` or `run` or `install` or `add`.
- Generator functions in `feature/`: prefix `generateFeature`.

---

## FVM Rules

- All `dart` and `flutter` commands in init helpers must go through `fvmExec(exe)` from `lib/src/functions/shared/fvm_exec.dart`.
- `fvmExec(exe)` checks once (cached) whether fvm is available and returns `['fvm', exe]` or `[exe]`.
- Use `flutter pub add` (not `dart pub add`) for adding dependencies.
- `fvmUse()` (async) is called once at the start of `runInit()` to let the user select a Flutter version interactively. It is a no-op if fvm is not installed.
- `runInit()` is `async` because of `fvmUse()`. Its `bin/` entry point and runner command must also be `async`/`Future<void>`.

---

## dart format & build_runner Rules

- `runDartFormat()` is called at the end of: `runInit()`, `addFeature()`, `addRepo()`, `addEntity()`.
- `runBuildRunner()` is called only from `runInit()`.
- Helper functions (under `lib/src/functions/`) must **never** call `runDartFormat()` or `runBuildRunner()` — only command functions do this.

---

## Monorepo Rules

- **Every command already gets monorepo support for free** — `ensurePubspec()` calls `resolveMonoRepoProject()`, which detects monorepos and changes `Directory.current` before any command logic runs.
- **Never add monorepo detection inside individual command files** — it lives exclusively in `lib/src/functions/shared/resolve_mono_repo_project.dart`.
- **New commands must call `ensurePubspec()` as their first statement** — this is what makes them monorepo-aware automatically.
- The global `--scope=<name>` flag is declared on `CleanHelperRunner.argParser` and stored in `resolveScope` (from `lib/src/functions/shared/scope_option.dart`) via an override of `runCommand`. No command file touches this.
- Detection logic (in order):
  1. `lib/` folder present → normal single-project flow, no selection prompt.
  2. `lib/` absent + `clean-helper.mono_repo_apps` in root pubspec:
     - `--scope` given, one match → auto-select.
     - `--scope` given, multiple matches (same name, different paths) → prompt from that subset.
     - `--scope` given, no match → `abort()` listing available names.
     - No `--scope`, one app declared → auto-select.
     - No `--scope`, multiple apps → full interactive prompt.
  3. `lib/` absent + no declaration → `abort()` with instructions to declare apps in pubspec.

---

## Version Stamping Rules

- `toolVersion` in `lib/src/functions/shared/tool_version.dart` **must always match** the `version:` field in `clean_helper/pubspec.yaml`.
- When bumping the package version, update both files.
- Never modify `clean-helper.version` in a target project's `pubspec.yaml` directly — it is written exclusively by `writeToolVersion()` at the end of `runInit()`.

---

## What NOT to Do

- Do not add logic to `bin/` files — they must only call the command function.
- Do not add more than one public function to any `.dart` file under `lib/src/`.
- Do not modify files that already exist in the target project without using `overwriteFile`.
- Do not use `package:` imports for cross-file references within a generated Flutter feature — always use relative imports.
- Do not embed template strings inline inside generator functions — extract to `lib/src/templates/`.
- Do not use `dart pub add` — always use `flutter pub add`.
- Do not call `dart` or `flutter` directly in init helpers — always use `fvmExec('dart')` or `fvmExec('flutter')`.
- Do not duplicate monorepo detection — it is handled once in `resolveMonoRepoProject()`; never replicate it in commands or helpers.
