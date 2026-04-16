# Command: init

**Entry point:** `lib/src/commands/init.dart` → `runInit()` [async]
**Binary:** `dart bin/init.dart`

---

## What It Does (in order)

1. `ensurePubspec()` — aborts if not run from a Flutter project root
2. `readPackageName()` — reads `name:` from `pubspec.yaml`
3. `fvmUse()` — if fvm is installed, runs `fvm use` interactively so the user can select a Flutter version
4. `createDirectories()` — creates the full folder scaffold
5. `generateLocalizationFiles()` — `slang.yaml` + `assets/locales/en.locale.json`
6. `generateFlutterGenFiles()` — `build.yaml` + `assets/colors/colors.xml`
7. `generateCleanRouterPackage()` — scaffolds `packages/clean_router` with `CleanRouterBase` + `CleanRouterRefresh`
8. `addCleanRouterWorkspace()` — patches root `pubspec.yaml` with `workspace: - packages/clean_router`
9. `generateCoreFiles(packageName)` — all core Dart files (main, bootstrap, DI, routing, string extension)
10. `generateUtilsFiles()` — `Failure`, `getCurrentFunctionName`, `safeCast`, `safeExecute`, `listToModelList`, type definitions
11. `generateHomeFeature(packageName)` — complete home feature scaffold
12. `generateToolsFiles()` — `tools/` scripts (command_runner, clean, bootstrap, build_android, build_config.json)
13. `installDependencies()` — `flutter pub add` for all runtime + dev deps
14. `updateGitignore()` — appends generated-file patterns to `.gitignore`
15. `addVscodeConfig()` — VS Code settings
16. `addFlutterAssetsToPubSpec()` — patches `pubspec.yaml` flutter.assets
17. `addNetworkModule()` — optional, only if `--network` or `--auth-interceptor` flag passed
18. `addAuthInterceptor()` — optional, only if `--auth-interceptor` flag passed
19. `runSlang()` — `[fvm] dart run slang`
20. `runBuildRunner()` — `[fvm] dart run build_runner build --delete-conflicting-outputs`
21. `runDartFormat()` — `[fvm] dart format .`

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
│   │   ├── di_container.dart        (GetIt instance)
│   │   ├── di_initializer.dart      (@InjectableInit)
│   │   ├── di_keys.dart
│   │   └── app_module.dart          (navigationKey, scaffoldMessengerKey)
│   ├── navigations/
│   │   └── home_navigation_impl.dart
│   └── router/
│       ├── app_go_router.dart
│       ├── app_go_router_redirect.dart
│       └── app_router_module.dart
├── core/
│   ├── di/
│   │   └── core_module.dart         (PackageInfo)
│   ├── domain/
│   │   ├── entities/
│   │   │   └── error_entity.dart
│   │   └── failures/
│   │       └── failure.dart         (Failure + leftFromError)
│   ├── data/models/
│   │   └── error_model.dart
│   ├── network/
│   │   ├── constants/api_paths.dart
│   │   ├── di/network_module.dart
│   │   └── interceptors/error_interceptor.dart
│   ├── utils/
│   │   ├── extensions/
│   │   │   └── string_extension.dart   (String.tr)
│   │   └── functions/
│   │       ├── get_current_function_name.dart
│   │       ├── type_definitions.dart
│   │       ├── safe_cast.dart
│   │       ├── safe_execute.dart
│   │       └── list_to_model_list.dart
│   └── generated/
│       ├── locales/                 (slang output)
│       └── flutter_gen/             (flutter_gen output)
└── features/
    └── home/
        └── ...                      (see add_feature.md for full structure)
assets/
├── locales/en.locale.json
└── colors/colors.xml
build.yaml
slang.yaml
analysis_options.yaml
tools/
├── command_runner.dart
├── clean.dart
├── bootstrap.dart
├── write_key_properties.dart
├── build_android.dart
└── config/
    └── android_build_config.json  ← gitignored
packages/
└── clean_router/                    (local workspace package)
```

---

## Dependencies Installed

All installed via `flutter pub add`.

**Runtime:**
`clean_router` (local path: `packages/clean_router`),
`flutter_bloc`, `go_router`, `get_it`, `injectable`, `freezed_annotation`,
`fpdart`, `slang`, `slang_flutter`, `package_info_plus`, `flutter_svg`,
`json_annotation`, `flutter_localizations` (SDK), `logger`

**Dev:**
`build_runner`, `injectable_generator`, `freezed`, `flutter_gen_runner`, `json_serializable`

**Git-hosted (added separately):**
`pretty_dio_logger`, `chucker_flutter`
