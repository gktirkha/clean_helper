# Rules for AI Agents

Hard constraints for changing clean_helper. `conventions.md` explains the reasoning; `extending.md` has step-by-step recipes.

---

## File structure

- **One public function per file** under `lib/src/`, named after the file (`sort_imports.dart` → `sortImports`). Two long-standing exceptions: `shared/write_file.dart` defines both `writeFile` and `overwriteFile`, and shared state files (`scope_option.dart`, `package_configs.dart`, `tool_version.dart`) hold variables or typedefs rather than a function.
- **Command files** (`lib/src/commands/`) contain exactly one function, the command entry point. Put helpers in `lib/src/functions/<group>/`.
- **New helpers get a new file.** Never add a second function to an existing file.
- **Templates** live in `lib/src/templates/`, one `…Template` function per file, returning `String`. Generator functions never contain inline template strings.
- `lib/clean_helper.dart` exports command files only — never functions or templates.
- `bin/` files only call a command function.

## Writing files in the target project

- Use `writeFile(path, content)` for files the user may edit. It skips files that already exist.
- Use `overwriteFile(path, content)` only for tool-owned files, such as `app_router_module.dart`, `analysis_options.yaml` or package scaffolding during `init`.
- Never call `File(...).writeAsStringSync` directly.
- Both helpers create parent directories, so never create directories before writing. `Directory.createSync` is allowed only in `init/create_directories.dart`, for empty folders `init` scaffolds.
- A command with an overwrite flag picks its writer once: `final write = overwrite ? overwriteFile : writeFile`.

## Paths and imports

- Every path is a plain relative string, relative to the **target project's** current directory. Don't use `path.join` or absolute paths.
- Inside clean_helper, import shared helpers as `../shared/<file>.dart` and templates as `../../templates/<file>.dart`. Templates may import from `../functions/shared/` (`camelCase`, `sortImports`, …). No circular imports.
- **Generated code** uses relative imports for files inside the app, and `package:` imports for other packages.
- Generated imports must satisfy `directives_ordering`. Build any import list containing a runtime value — a configured package or a user-derived name — with `sortImports([...])`, one call per section (`dart:`, then `package:`, then relative). A configured import may be either a package URI or a relative path, so check `startsWith('package:')` and put it in the matching section.

## Naming in generated code

- Feature and repo names arrive in snake_case. Use `pascalCase(x)` for classes, `camelCase(x)` for **every** identifier (fields, parameters, constants), and `kebabCase(x)` for URL paths. Never put a raw snake_case name in an identifier.

## Commands and monorepos

- **Every command calls `ensurePubspec()` first.** It loads the root-pubspec config, handles monorepo app selection (which changes `Directory.current`) and checks the version stamp. The only exceptions are `list-mono-repo-apps`, which must not trigger selection, and the global `--version` flag, which is handled in the runner.
- Never add monorepo detection anywhere except `shared/resolve_mono_repo_project.dart`.
- Anything read from the **root** pubspec must be read in `loadPackageConfigs()` — which `ensurePubspec()` calls before the directory change — and stored in a shared global in `shared/package_configs.dart`. Commands read the global; they never re-read the root pubspec.
- New `clean-helper:` keys are parsed with `readCleanHelperFields(path)`. Missing keys must keep today's behaviour.

## Compatibility with existing projects

- Generated code has to compile in projects scaffolded by **older** versions. When a template change depends on something `init` generates (the call adapter, `UseCaseBase`, utils exports, DI registrations), either detect the old layout from files on disk, or add a config key and document the upgrade step in the README's "Upgrading existing projects" table.
- Never register a type in DI that an older layout already registers — GetIt throws on duplicates. See `utils_registers_error_logger.dart`.

## Toolchain

- Run every `dart`/`flutter` command through `fvmExec('dart')` / `fvmExec('flutter')`.
- Add dependencies with `flutter pub add`, never `dart pub add`.
- Only command functions call `runDartFormat()` and `runBuildRunner()`, never helpers.

## Versioning and docs

- `toolVersion` in `shared/tool_version.dart` must always equal `version:` in `pubspec.yaml`. Bump both together, and add a CHANGELOG section for the new version.
- Never edit `clean-helper.version` in a target project; only `writeToolVersion()` writes it.
- A behaviour change updates `README.md`, the matching `.agents/commands/<command>.md`, and `structure.md` for new or renamed files.
- After changing the source, `dart analyze` must report no issues and `dart format` must leave nothing to change.
