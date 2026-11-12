# Code Conventions

The reasoning behind the rules in `agent_rules.md`.

---

## Layers

```
bin/clean_helper.dart   the only entry point: CleanHelperRunner().run(args)
lib/src/runner/         args + cli_completion wiring (CleanHelperRunner, one Command class per command)
lib/src/commands/       one entry-point function per command
lib/src/functions/      helpers, grouped by command (init/, feature/, repo/, …) plus shared/
lib/src/templates/      generated file contents, one template function per file
```

A command function reads as a script: `ensurePubspec()`, validate the arguments, call helpers, format, and run build_runner. Helpers do one thing each. Templates are pure: arguments in, `String` out, with no file I/O.

---

## One function per file

This keeps files small and searchable, and makes the file name the function name:

```dart
// ✅ lib/src/functions/repo/generate_domain_repo.dart
void generateDomainRepo(String dir, String name, String utilsImport, {...}) {
  writeFile('$dir/${name}_repository.dart', domainRepoTemplate(...));
}

// ❌ a second function in the same file
```

---

## Templates

- They return the whole file as a `String`. Use an arrow body for simple templates, and a block body when they compute pieces first (see `rest_data_source_template.dart`).
- Escape `$` for Dart code that must appear literally in the output: `'\${packageInfo.appName}'`.
- A multi-line `'''` string drops the newline right after the opening quotes. To start a fragment with a blank line, use `'\n\n...'`.
- Optional output is controlled by named `bool` parameters that default to today's behaviour (`addSample`, `withDi`, `auth`).
- Imports that depend on runtime values go through `sortImports([...])`, one call per section:

```dart
${sortImports([
  "import 'package:fpdart/fpdart.dart';",
  "import '$utilsImport';",          // configured, so its position varies
])}

${sortImports([
  "import '../constants/api_paths.dart';",
  if (auth) "import '../interceptors/app_auth_interceptor.dart';",  // conditional, so sort
])}
```

- Templates take the **full import URI** (`utilsImport`), not a package name. That lets a configured barrel (`packages.utils.import`) work unchanged.

---

## writeFile vs overwriteFile

| Helper | Behaviour | Use for |
|---|---|---|
| `writeFile(path, content)` | Skips an existing file and logs the skip | Anything the user may edit — nearly everything |
| `overwriteFile(path, content)` | Always writes | Tool-owned files: `<app>_router_module.dart`, package scaffolding, pubspec patches |
| `writeAnalysisOptions(path, content)` | `overwriteFile`, or `writeFile` with `overwrite_analysis_options: false` | Every `analysis_options.yaml` |

Both create parent directories.

---

## Case helpers (`functions/shared/`)

| Helper | `user_profile` → |
|---|---|
| `pascalCase` | `UserProfile` — class names |
| `camelCase` | `userProfile` — identifiers, fields, parameters, constants |
| `kebabCase` | `user-profile` — URL paths |

---

## Config and monorepo state

The runner and `ensurePubspec()` fill shared globals before any command logic runs:

| Global (file) | Set by | Meaning |
|---|---|---|
| `resolveScope` (`scope_option.dart`) | `CleanHelperRunner.runCommand` | `--scope` value |
| `packageConfigsLoaded` (`package_configs.dart`) | `loadPackageConfigs()` | config already loaded — `ensurePubspec()` loads it only once per process, so nested commands (`init` → `add-network-module`) keep the root config after the monorepo `chdir` |
| `packageCreateConfig` | `loadPackageConfigs()` | `packages.<key>.create` per key, read even without `name`/`import`; the `resolve*Package()` defaults use it |
| `utilsPackageConfig` | `loadPackageConfigs()` | `packages.utils` as a `PackageConfig` `(name, import, create)`, or null |
| `localizationPackageConfig`, `routerPackageConfig` | `loadPackageConfigs()` | `packages.localization` / `packages.router`, or null |
| `networkPackageConfig` | `loadPackageConfigs()` | `packages.network`, or null |
| `networkModuleNameConfig`, `networkAuthInterceptorConfig` | `loadPackageConfigs()` | `packages.network.module_name` (or null) / `.auth_interceptor` (true unless `false`) |
| `utilsModuleNameConfig`, `callAdapterNameConfig` | `loadPackageConfigs()` | `packages.utils.module_name` / `.call_adapter_name`, or null |
| `slangSettingsConfig` | `loadPackageConfigs()` | every other scalar key under `packages.localization` |
| `overwriteAnalysisOptionsConfig` | `loadPackageConfigs()` | `packages.overwrite_analysis_options`; true unless `false`. `writeAnalysisOptions()` picks `overwriteFile` / `writeFile` from it, for app, root and package files alike |
| `useRootAnalysisConfig` | `loadPackageConfigs()` | `packages.use_root_analysis`; true unless `false` |
| `monoRepoAppPath` | `resolveMonoRepoProject()` | the app switched into, relative to the root (`apps/shop`), or null |

`loadPackageConfigs()` runs **before** `resolveMonoRepoProject()` changes directory, so it reads the root pubspec. Config parsing is line-based, with no YAML dependency:

- `readCleanHelperFields(path)` returns the scalar children of `clean-helper.<path…>`. It tracks indentation, strips comments and quotes, and ignores list items.
- `readPackageConfig(key)` builds on it for `packages.<key>`: the name comes from the import, or the import defaults to `package:<name>/<name>.dart`; `create` is true unless it's `false`.
- `readMonoRepoApps()` is a hand-written parser for the `mono_repo_apps` list, which `readCleanHelperFields` (scalars only) can't read. `checkVersionMismatch()` reads `version` through `readCleanHelperFields([])`.

Resolution helpers turn config into decisions, so commands don't repeat the logic:

| Helper | Decides |
|---|---|
| `resolveUtilsPackage()`, `resolveLocalizationPackage()`, `resolveRouterPackage()`, `resolveNetworkPackage()` | the configured package, or the default `<app>_utils` / `<app>_localization` / `clean_router` / `<app>_network` with `create: true` — commands never build default names themselves |
| `resolveSlangSettings()` | the slang defaults overlaid with `slangSettingsConfig` |
| `analysisOptionsInclude(dir)` | the `include:` path for the `analysis_options.yaml` at `dir` (`''` = the current project), or null for the full rules — `'../' × (depth(dir) + depth(monoRepoAppPath) with use_root_analysis)` |
| `resolveNetworkModuleName(network)` | `module_name` ?? `<NetworkPascal>Module` |
| `resolveUtilsModuleName(utils)` | `module_name` ?? `<UtilsPascal>Module` |
| `resolveCallAdapterName()` | `call_adapter_name` ?? `RetrofitCallAdapter` |
| `packageBarrelPath(p)` / `packageBarrelPrefix(p)` | where a created package's barrel goes (from its import URI), and the `../` prefix its exports need |

---

## `ensurePubspec()` and `abort()`

- `ensurePubspec()` is the first statement of every command, except those that work on the current directory (`add-config`, `add-melos-config`, `add-vscode-extensions`, `create-packages`, `list-mono-repo-apps`).
- `abort(message)` returns `Never`: it prints `❌ message` to stderr and exits with code 1. Use it for unrecoverable input or config errors. Use `stderr.writeln('⚠️ …')` for warnings that shouldn't stop the command.

---

## External commands

`runCommand(cmd, {workingDirectory})` runs a process and, on a non-zero exit, prints its output and aborts. `runCommandStreamed(cmd)` prints the output as-is and aborts the same way. Later steps (patching a pubspec, running build_runner) assume earlier ones succeeded, so a failure must stop the run.

---

## Output style

The command output uses emoji-prefixed lines: `🚀` start, `📄` file written, `⏭` skipped, `⚠️` warning, `✅` done. Keep new messages consistent with the surrounding command.

---

## fvm

`fvmExec('dart' | 'flutter')` returns `['fvm', exe]` when fvm is installed, otherwise `[exe]`; the check is cached. `fvmUse()` (async) runs `fvm use` interactively at the start of `init` and `bootstrap`. It does nothing in a monorepo app (`monoRepoAppPath` set): the Flutter version is pinned at the workspace root. For the same reason `generateToolsFiles()` writes nothing in a monorepo app.
