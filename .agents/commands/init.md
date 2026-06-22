# Command: init

**Entry point:** `lib/src/commands/init.dart` → `runInit()` [async]
**Binary:** `dart bin/init.dart`

---

## What It Does (in order)

1. `ensurePubspec()` — aborts if not run from a Flutter project root
2. `readPackageName()` — reads `name:` from `pubspec.yaml`; derives `utilsPackageName` and `localizationPackageName`
3. `fvmUse()` — if fvm is installed, runs `fvm use` interactively
4. `generateAnalysisOptions()` — writes `analysis_options.yaml`
5. `runFlutterPubGet()` — pub get before any deps are added
6. `createDirectories()` — creates main app folder scaffold only
7. `generateLocalizationFiles()` — no-op (localization lives in the localization package)
8. `generateFlutterGenFiles()` — `build.yaml` + `assets/colors/colors.xml`
9. `generateCleanRouterPackage()` — scaffolds `packages/clean_router` via `flutter create --template package`
10. `generateLocalizationPackage(localizationPackageName)` — scaffolds `packages/<app>_localization` (slang.yaml, locale JSON, string extension)
11. `generateUtilsPackage(utilsPackageName, localizationPackageName)` — scaffolds `packages/<app>_utils` (all shared utils + DI micro-package)
12. `addCleanRouterWorkspace(utilsPackageName, localizationPackageName)` — patches root `pubspec.yaml` with `workspace:` entries for all three packages
13. `generateCoreFiles(packageName, utilsPackageName)` — main, bootstrap, DI (wired to `<App>UtilsPackageModule`), routing
14. `generateUtilsFiles(utilsPackageName)` — only `use_case_base.dart` in main app
15. `generateHomeFeature(packageName)` — complete home feature scaffold
16. `generateToolsFiles()` — optional, only with `--tools` flag
17. `installDependencies(utilsPackageName, localizationPackageName)` — `flutter pub add` for all deps + path deps for all three local packages
18. `updateGitignore()`, `addVscodeConfig()`, `addFlutterAssetsToPubSpec()`
19. `addNetworkModule()` — optional, only if `--network` or `--auth-interceptor` flag
20. `addAuthInterceptor()` — optional, only if `--auth-interceptor` flag
21. `runSlang(localizationPackageName)` — `[fvm] dart run slang` inside `packages/<app>_localization`
22. `runBuildRunner(workingDirectory: 'packages/<app>_utils')` — generates `<App>UtilsPackageModule` first
23. `runBuildRunner()` — builds root app (depends on PackageModule from step 22)
24. `runDartFormat()` — `[fvm] dart format .`
25. `sortPubspecDeps()` — sorts root `pubspec.yaml`
26. `sortPubspecDeps('packages/<app>_utils/pubspec.yaml')` — sorts utils package deps
27. `sortPubspecDeps('packages/<app>_localization/pubspec.yaml')` — sorts localization package deps
28. `writeToolVersion()` — stamps `clean-helper.version: <version>` in root `pubspec.yaml`

`[fvm]` means the command is prefixed with `fvm` automatically if fvm is detected.

---

## Flags

| Flag | Short | Description |
|------|-------|-------------|
| `--network` | `-n` | Also set up the network layer (Dio, Retrofit, Chucker) |
| `--di` | `-d` | Also generate DI module for the home feature |
| `--auth-interceptor` | `-a` | Also scaffold auth interceptor (implies `--network`) |

---

## Generated Structure in Target Project

```
lib/
├── main.dart
├── app/
│   ├── bootstrap.dart
│   ├── main_app.dart
│   ├── di/
│   │   ├── di_container.dart
│   │   ├── di_initializer.dart      (@InjectableInit + externalPackageModulesAfter: [<App>UtilsPackageModule])
│   │   ├── di_keys.dart
│   │   └── app_module.dart
│   ├── navigations/
│   │   └── home_navigation_impl.dart
│   └── router/
│       ├── app_go_router.dart
│       ├── app_go_router_redirect.dart
│       └── app_router_module.dart
├── core/
│   ├── di/
│   │   └── core_module.dart
│   ├── domain/
│   │   └── use_cases/
│   │       └── use_case_base.dart
│   └── data/models/
│       └── error_model.dart         (@freezed, implements ErrorEntity from utils package)
└── features/
    └── home/
        └── ...                      (see add_feature.md for full structure)
assets/
└── colors/colors.xml
build.yaml
analysis_options.yaml
packages/
├── clean_router/                    (workspace package — router base classes)
├── <app>_localization/              (workspace package)
│   ├── slang.yaml                   (output_directory: lib/src/generated)
│   ├── assets/locales/en.locale.json
│   └── lib/
│       ├── <app>_localization.dart
│       └── src/
│           ├── string_extension.dart
│           └── generated/locales.g.dart   ← slang output
└── <app>_utils/                     (workspace package)
    └── lib/
        ├── <app>_utils.dart
        └── src/
            ├── app_logger.dart
            ├── bloc_observer.dart
            ├── debouncer.dart
            ├── error_entity.dart
            ├── failure.dart
            ├── type_definitions.dart
            ├── di/
            │   ├── <app>_utils_module.dart    (@module — BlocObserver, RetrofitLogger)
            │   └── di_initializer.dart        (@InjectableInit.microPackage)
            ├── functions/
            │   ├── get_current_function_name.dart
            │   ├── list_to_model_list.dart
            │   ├── safe_cast.dart
            │   └── safe_execute.dart
            └── network/
                ├── retrofit_call_adapter.dart
                └── retrofit_logger.dart
```

---

## Dependencies Installed

All installed via `flutter pub add`.

**Runtime (main app):**
`flutter_bloc`, `go_router`, `get_it`, `injectable`, `freezed_annotation`,
`fpdart`, `package_info_plus`, `flutter_svg`, `json_annotation`,
`flutter_localizations` (SDK), `logger`

**Dev (main app):**
`build_runner`, `injectable_generator`, `freezed`, `flutter_gen_runner`, `json_serializable`

**Local path deps (main app):**
`clean_router` (`packages/clean_router`),
`<app>_localization` (`packages/<app>_localization`),
`<app>_utils` (`packages/<app>_utils`)

**Utils package deps:**
`dio`, `flutter_bloc`, `fpdart`, `injectable`, `logger`, `retrofit`, `<app>_localization`
Dev: `build_runner`, `injectable_generator`

**Localization package deps:**
`slang`, `slang_flutter`
