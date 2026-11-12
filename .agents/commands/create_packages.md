# Command: create-packages

**Entry point:** `lib/src/commands/create_packages.dart` → `createPackages({dir})`
**Runner:** `CreatePackagesCommand` — option `--dir=<path>` (default `packages`)

## Usage

```bash
clean-helper create-packages
clean-helper create-packages --dir=shared/libs
```

Run from the workspace root. It's idempotent: a package whose folder already has a `pubspec.yaml` isn't regenerated.

## Behaviour

- **Doesn't call `ensurePubspec()`**: packages are created relative to the current directory (typically the monorepo root), and `ensurePubspec()` would switch into an app first. It checks for `pubspec.yaml` itself and calls `loadPackageConfigs()` directly.
- `dir` is trimmed of a leading `./` and trailing `/`; empty means `packages`.
- Resolves the packages with `resolveUtilsPackage()`, `resolveLocalizationPackage()`, `resolveRouterPackage()` and `resolveSlangSettings()`. Defaults use the current pubspec's `name`. **`create` is ignored.**
- Also creates the network package (`generateNetworkPackage`) when `packages.network` is configured.
- Generates the missing packages with the same helpers as `init`, each with `parentDir: dir`: `generateCleanRouterPackage`, `generateLocalizationPackage`, `generateUtilsPackage` (`moduleName: resolveUtilsModuleName(utils)`).
- Then, for every package found under `dir` (created now or by an earlier, possibly interrupted run): `writeFile('analysis_options.yaml', full rules)` (the packages include it); `addPackagesWorkspace(['<dir>/<name>', …])`, which also warns about stale `workspace:` entries; `runFlutterPubGet()`; `runSlang(localization, parentDir: dir)`; `runBuildRunner` in the utils and network packages; `sortPubspecDeps` for all but the router; `runDartFormat()`. So rerunning after a failure finishes the setup.
- It doesn't add the packages as dependencies of any app. `init` does that, without `path:`.
