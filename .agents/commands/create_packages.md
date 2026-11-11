# Command: create-packages

**Entry point:** `lib/src/commands/create_packages.dart` → `createPackages({dir})`
**Runner:** `CreatePackagesCommand` — option `--dir=<path>` (default `packages`)

## Usage

```bash
clean-helper create-packages
clean-helper create-packages --dir=shared/libs
```

Run from the workspace root. It's idempotent: a package whose folder already has a `pubspec.yaml` is skipped.

## Behaviour

- **Doesn't call `ensurePubspec()`**: packages are created relative to the current directory (typically the monorepo root), and `ensurePubspec()` would switch into an app first. It checks for `pubspec.yaml` itself and calls `loadPackageConfigs()` directly.
- `dir` is trimmed of a leading `./` and trailing `/`; empty means `packages`.
- Resolves the packages with `resolveUtilsPackage()`, `resolveLocalizationPackage()`, `resolveRouterPackage()` and `resolveSlangSettings()`. Defaults use the current pubspec's `name`. **`create` is ignored.**
- Generates the missing packages with the same helpers as `init`, each with `parentDir: dir`: `generateCleanRouterPackage`, `generateLocalizationPackage`, `generateUtilsPackage` (`moduleName: resolveUtilsModuleName(utils)`).
- Then, if anything was created: `addPackagesWorkspace(['<dir>/<name>', …])`, which adds `workspace:` at the end of the pubspec when it has no `dependencies:`; `runFlutterPubGet()`; `runSlang(localization, parentDir: dir)`; `runBuildRunner` in the utils package; `sortPubspecDeps` for the localization and utils pubspecs; `runDartFormat()`.
- It doesn't add the packages as dependencies of any app. `init` does that, without `path:`.
