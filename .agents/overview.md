# Project Overview

`clean_helper` is a Dart CLI (`clean-helper`) that scaffolds Flutter apps in Clean Architecture and generates features, repositories, entities and the network layer in a consistent shape. It runs against a **target Flutter project**: every path it writes is relative to that project, never to this repo.

Read next:

| File | For |
|---|---|
| `agent_rules.md` | Hard rules — read before changing anything |
| `conventions.md` | How the code is organised, and why |
| `structure.md` | Where every file in this repo lives |
| `architecture.md` | What the generated Flutter project looks like |
| `extending.md` | Recipes: new command, template, config key |
| `commands/<command>.md` | Per-command behaviour and implementation notes |

---

## Commands

| Command | Entry point | Summary |
|---|---|---|
| `init` | `runInit()` (async) | Full scaffold of a new Flutter project |
| `bootstrap` | `runBootstrapCommand()` (async) | `fvm use` → pub get → slang → build_runner |
| `add-feature <name>` | `addFeature(args)` | Feature routes, router, navigation, bloc, page |
| `add-repo <feature> <name>` | `addRepo(args)` | Data + domain layer for a repository |
| `add-entity <scope> <name> [folder]` | `addEntity(args)` | Entity + freezed model |
| `add-network-module` | `addNetworkModule()` | Dio/Retrofit network layer |
| `add-auth-interceptor` | `addAuthInterceptor()` | Token-refresh interceptor wired into `NetworkModule` |
| `remove-feature <name>` | `removeFeature(args)` | Delete a feature, unregister its router |
| `regenerate-router` | `regenerateRouter()` | Rebuild `app_router_module.dart` from disk |
| `build-runner [build\|clean]` | `runBuildRunnerCommand(args)` | Run build_runner |
| `generate-localizations` | `runGenerateLocalizationsCommand(args)` | Run slang (see Known issues) |
| `generate-tools [--overwrite]` | `generateTools(overwrite:)` | `tools/` scripts |
| `add-vscode-config` | `addVscodeConfig()` | `.vscode/` files |
| `list-mono-repo-apps` | `listMonoRepoApps()` | Print monorepo apps and resolved config |

Global flags, declared on `CleanHelperRunner` and handled in its `runCommand` override:

- `--scope=<app>` — stored in `resolveScope`; narrows monorepo app selection.
- `--version` — calls `printVersion()` and returns before any command runs.

`lib/src/commands/add_network.dart` (`addNetwork()`) is a legacy entry point with no runner command and no export. Keep it compiling, but don't extend it.

---

## Configuration keys (`clean-helper:` in pubspec.yaml)

| Key | Read by | Stored in |
|---|---|---|
| `version` | `checkVersionMismatch()` — **after** the monorepo directory change | — |
| `mono_repo_apps` | `readMonoRepoApps()` | — |
| `packages.utils.{name,import}` | `loadPackageConfigs()` | `utilsPackageConfig` |
| `packages.network.{name,import}` | `loadPackageConfigs()` | `networkPackageConfig` |
| `retrofit_call_adapter.{name,import}` | `loadPackageConfigs()` | `retrofitCallAdapterConfig` |
| `result_type` (`task_either` \| `future_either`) | `loadPackageConfigs()` | `resultTypeConfig` |

Everything except `version` is read from the pubspec in the starting directory — the monorepo root in a monorepo — before `resolveMonoRepoProject()` changes directory. The README's Configuration section documents each key's behaviour for users.

---

## Command lifecycle

```
bin/clean_helper.dart → CleanHelperRunner.run(args)
  runCommand(): --version? → printVersion(), return
                resolveScope = --scope
  <Command>.run() → command function
     ensurePubspec()
       ├─ abort unless ./pubspec.yaml exists
       ├─ loadPackageConfigs()      reads root-pubspec config into globals
       ├─ resolveMonoRepoProject()  no lib/? pick an app, chdir into it
       └─ checkVersionMismatch()    warns if clean-helper.version ≠ toolVersion
     … generate files (writeFile / overwriteFile) …
     runDartFormat(); runBuildRunner()   (generating commands only)
```

---

## `init` sequence

1. `ensurePubspec()`; `readPackageName()` → `<app>`, `<app>_utils`, `<app>_localization`
2. `fvmUse()`
3. `generateAnalysisOptions()`, `runFlutterPubGet()`
4. `createDirectories()` — empty app folders, including the home feature's
5. `generateLocalizationFiles()` — no-op, kept for ordering
6. `generateFlutterGenFiles()` — `build.yaml`, `assets/colors/colors.xml`
7. `generateCleanRouterPackage()`, `generateLocalizationPackage()`, `generateUtilsPackage()`
8. `addCleanRouterWorkspace()` — adds all three packages to `workspace:`
9. `generateCoreFiles()` — main, bootstrap, app, DI, router
10. `generateUtilsFiles()` — `lib/core/domain/use_cases/use_case_base.dart`
11. `generateHomeFeature()`; `generateToolsFiles()` with `--tools`
12. `installDependencies()`, `updateGitignore()`, `addVscodeConfig()`, `addFlutterAssetsToPubSpec()`
13. `addNetworkModule(runBuildRunnerAfter: false)` with `--network` / `--auth-interceptor`; `addAuthInterceptor(...)` with `--auth-interceptor`
14. `runSlang(<app>_localization)`
15. `runBuildRunner(workingDirectory: packages/<app>_utils)`, then `runBuildRunner()` for the app
16. `runDartFormat()`
17. `sortPubspecDeps()` for the app, utils and localization pubspecs
18. `writeToolVersion()`

---

## Versioning

- `toolVersion` (`shared/tool_version.dart`) must match `version:` in `pubspec.yaml`.
- Every release gets a `CHANGELOG.md` section. Released versions aren't amended — later changes go in a new patch version.
- Template changes that older projects can't absorb are recorded in the README's "Upgrading existing projects" table.

---

## Known issues

- `generate-localizations` runs `dart run slang` in the app root, but since 1.3.0 `slang.yaml` lives in `packages/<app>_localization`. `bootstrap` and `init` use `runSlang(<app>_localization)`, which is correct. The generated `tools/bootstrap.dart` has the same problem as `generate-localizations`.
- `bootstrap` runs build_runner only in the app, not first in `packages/<app>_utils` as `init` does.
- `add-repo` never adds a constant to an existing `<feature>_api_paths.dart`, so a second repo in the same feature references a missing constant.
