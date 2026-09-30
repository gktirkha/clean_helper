# Command: init

**Entry point:** `lib/src/commands/init.dart` → `runInit({withNetwork, withDi, withAuthInterceptor, withTools})` (async)
**Runner:** `InitCommand` — `clean-helper init`

## Usage

```bash
clean-helper init [--network|-n] [--auth-interceptor|-a] [--di|-d] [--tools|-t]
```

Run once, in a project fresh from `flutter create`. `--auth-interceptor` implies `--network`.

## Sequence

`ensurePubspec()` runs first. `readPackageName()` then derives `<app>`, `<app>_utils` and `<app>_localization`. The rest is in `overview.md` → "`init` sequence". In brief:

1. `fvmUse()`, `generateAnalysisOptions()`, `runFlutterPubGet()`
2. `createDirectories()`, `generateFlutterGenFiles()`
3. The packages: `generateCleanRouterPackage()`, `generateLocalizationPackage()`, `generateUtilsPackage()`, then `addCleanRouterWorkspace()`
4. The app: `generateCoreFiles()`, `generateUtilsFiles()` (`UseCaseBase`), `generateHomeFeature(withDi:)`, `generateToolsFiles()` if `--tools`
5. `installDependencies()`, `updateGitignore()`, `addVscodeConfig()`, `addFlutterAssetsToPubSpec()`
6. `addNetworkModule(runBuildRunnerAfter: false)` / `addAuthInterceptor(runBuildRunnerAfter: false, showNextSteps: false)` when their flags are set
7. `runSlang()` in the localization package; `runBuildRunner()` in `packages/<app>_utils`, then in the app; `runDartFormat()`
8. `sortPubspecDeps()` for all three pubspecs; `writeToolVersion()`

The package generators run `flutter create --template package` and then:

- delete the scaffold files (README, CHANGELOG, LICENSE, `test/`);
- overwrite `analysis_options.yaml`;
- patch the pubspec tail (`resolution: workspace`, dependencies) via `patchPackagePubspec()`;
- write their sources with `overwriteFile`.

## What it generates

See `architecture.md` for the full tree. Key points:

- The utils package holds `Failure`, `AppLogger`, `safeExecute`, `safeExecuteTask` and the rest, plus an injectable micro-package registering `BlocObserver`. Since 1.4.4 it no longer contains `RetrofitCallAdapter` / `RetrofitLogger`, and doesn't depend on `dio` or `retrofit`.
- `lib/core/domain/use_cases/use_case_base.dart`: `UseCaseBase.call` returns `FutureOr<TaskEither<Failure, ReturnType>>`.
- The home feature is generated with the same helpers as `add-feature`, plus empty `data/` and `domain/` folders from `createDirectories()`.

## Dependencies

- **App runtime:** `flutter_bloc`, `go_router`, `get_it`, `injectable`, `freezed_annotation`, `fpdart`, `package_info_plus`, `flutter_svg`, `json_annotation`, `logger`, `flutter_localizations` (SDK)
- **App dev:** `build_runner`, `injectable_generator`, `freezed`, `flutter_gen_runner`, `json_serializable`
- **App path:** `clean_router`, `<app>_localization`, `<app>_utils`
- **Utils package:** `flutter_bloc`, `fpdart`, `injectable`, `logger`, `<app>_localization`; dev `build_runner`, `injectable_generator`
- **Localization package:** `slang`, `slang_flutter`

## Notes

- `init` doesn't read `clean-helper.packages`. It always generates `<app>_utils` and `<app>_localization`.
- The home feature's generators take `packageName` but otherwise match `add-feature`.
