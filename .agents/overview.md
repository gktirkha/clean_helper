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
| `add-feature <name>` | `addFeature(args, {withDi, runBuildRunnerAfter})` | Feature routes, router, navigation, bloc, page |
| `add-repo <feature> <name>` | `addRepo(args, {runBuildRunnerAfter, noRest, addSample})` | Data + domain layer for a repository |
| `add-entity <scope> <name> [folder]` | `addEntity(args, {runBuildRunnerAfter})` | Entity + freezed model |
| `add-network-module` | `addNetworkModule({runBuildRunnerAfter})` | Create the network package and wire the app to it |
| `remove-feature <name>` | `removeFeature(args, {runBuildRunnerAfter})` | Delete a feature, unregister its router |
| `regenerate-router` | `regenerateRouter()` | Rebuild `<app>_router_module.dart` from disk |
| `build-runner [build\|clean]` | `runBuildRunnerCommand(args)` | Run build_runner |
| `generate-localizations` | `runGenerateLocalizationsCommand()` | Run slang in `packages/<localization>` |
| `generate-tools [--overwrite]` | `generateTools(overwrite:)` | `tools/` scripts |
| `list-mono-repo-apps` | `listMonoRepoApps()` | Print monorepo apps and resolved config |
| `create-packages [--dir]` | `createPackages(dir:)` | Create the configured utils / localization / router packages (+ network when `packages.network` is configured) in `<dir>` (default `packages`), ignoring `create` |
| `add-vscode-extensions` | `addVscodeExtensions()` | Add recommended extensions to `.vscode/extensions.json` (merges) |
| `add-config` | `addConfig()` | Append the commented `clean-helper:` template to the current pubspec |
| `add-melos-config` | `addMelosConfig()` | melos dev dependency + `melos:` hooks and scripts in the root pubspec |

Global flags, declared on `CleanHelperRunner` and handled in its `runCommand` override:

- `--scope=<app>` — stored in `resolveScope`; narrows monorepo app selection.
- `--version` — calls `printVersion()` and returns before any command runs.


---

## Configuration keys (`clean-helper:` in pubspec.yaml)

| Key | Read by | Stored in |
|---|---|---|
| `version` | `checkVersionMismatch()` — **after** the monorepo directory change | — |
| `mono_repo_apps` | `readMonoRepoApps()` | — |
| `packages.<key>.create` (each package) | `loadPackageConfigs()` | `packageCreateConfig` (also in the `PackageConfig` when `name`/`import` is set) |
| `packages.utils.{name,import,create}` | `loadPackageConfigs()` | `utilsPackageConfig` |
| `packages.utils.module_name` / `.call_adapter_name` | `loadPackageConfigs()` | `utilsModuleNameConfig` / `callAdapterNameConfig` |
| `packages.localization.{name,import,create}` | `loadPackageConfigs()` | `localizationPackageConfig` |
| `packages.localization.<slang key>` | `loadPackageConfigs()` | `slangSettingsConfig` |
| `packages.overwrite_analysis_options` (or `clean-helper.overwrite_analysis_options`) | `loadPackageConfigs()` | `overwriteAnalysisOptionsConfig` |
| `packages.use_root_analysis` (or `clean-helper.use_root_analysis`) | `loadPackageConfigs()` | `useRootAnalysisConfig` |
| `packages.router.{name,import,create}` | `loadPackageConfigs()` | `routerPackageConfig` |
| `packages.network.{name,import,create}` | `loadPackageConfigs()` | `networkPackageConfig` |
| `packages.network.module_name` / `.auth_interceptor` | `loadPackageConfigs()` | `networkModuleNameConfig` / `networkAuthInterceptorConfig` |

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
       ├─ loadPackageConfigs()      reads root-pubspec config into globals (first call only)
       ├─ resolveMonoRepoProject()  no lib/? pick an app, chdir into it
       └─ checkVersionMismatch()    warns if clean-helper.version ≠ toolVersion
     … generate files (writeFile / overwriteFile) …
     runDartFormat(); runBuildRunner()   (generating commands only)
```

`add-config`, `add-melos-config`, `add-vscode-extensions`, `create-packages` and `list-mono-repo-apps` skip `ensurePubspec()`: they work on the current directory and never switch into an app.

---

## `init` sequence

1. `ensurePubspec()`; `resolveUtilsPackage()`, `resolveLocalizationPackage()`, `resolveRouterPackage()`, `resolveSlangSettings()`
2. `fvmUse()` — skipped in a monorepo app
3. `generateAnalysisOptions()`, `runFlutterPubGet()`
4. `createDirectories()` — empty app folders, including the home feature's
5. `generateFlutterGenFiles()` — `build.yaml`, `assets/colors/colors.xml`
6. `generateCleanRouterPackage()`, `generateLocalizationPackage()`, `generateUtilsPackage()` — each only when its `create` is true
7. `addPackagesWorkspace(created)` — lists the created packages under `workspace:`; adds nothing when none are created
8. `generateCoreFiles()` — main, bootstrap, init service, app, DI, router
9. `createFeatureStructure('lib/features/home', 'home', …)`
10. `installDependencies()`, `updateGitignore()`, `addFlutterAssetsToPubSpec()`
11. `addNetworkModule(runBuildRunnerAfter: false)` with `--network`; `writePackageAnalysisOptions` for every package under `packages/`; then `generateToolsFiles()` with `--tools` (after the network package, so `tools/bootstrap.dart` includes it)
12. `runSlang(<localization>)` — only if created
13. `runBuildRunner` in `packages/<utils>` (if created) and `packages/<network>` (with `--network`), then `runBuildRunner()` for the app
14. `runDartFormat()`
15. `sortPubspecDeps()` for the app and the created utils / localization pubspecs
16. `writeToolVersion()`

---

## Versioning

- `toolVersion` (`shared/tool_version.dart`) must match `version:` in `pubspec.yaml`.
- Every release gets a `CHANGELOG.md` section. Released versions aren't amended — later changes go in a new patch version.
- Older projects aren't supported: templates only target what the current `init` generates. Breaking changes are called out in the CHANGELOG.
