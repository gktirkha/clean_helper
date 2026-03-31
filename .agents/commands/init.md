# Command: init

**Entry point:** `lib/src/commands/init.dart` → `runInit()`
**Binary:** `dart run bin/init.dart`

---

## What It Does (in order)

1. `ensurePubspec()` — aborts if not run from a Flutter project root
2. `readPackageName()` — reads `name:` from `pubspec.yaml`
3. `createDirectories()` — creates the full folder scaffold
4. `generateLocalizationFiles()` — `slang.yaml` + `assets/locales/en.locale.json`
5. `generateFlutterGenFiles()` — `build.yaml` + `assets/colors/colors.xml`
6. `generateCleanRouterPackage()` — scaffolds `packages/clean_router` with `CleanRouterBase` + `CleanRouterRefresh`
7. `addCleanRouterWorkspace()` — patches root `pubspec.yaml` with `workspace: - packages/clean_router`
8. `generateCoreFiles(packageName)` — all core Dart files (main, bootstrap, DI, routing, string extension)
9. `generateUtilsFiles()` — `Failure`, `getCurrentFunctionName`, `safeCast`, `safeExecute`, `listToModelList`, type definitions
10. `generateHomeFeature(packageName)` — complete home feature scaffold
11. `installDependencies()` — `dart pub add` / `flutter pub add`
12. `addFlutterAssetsToPubSpec()` — patches `pubspec.yaml` flutter.assets
13. `addNetworkModule()` — optional, only if `--network` flag passed
14. `runSlang()` — `dart run slang`
15. `runBuildRunner()` — `dart run build_runner build --delete-conflicting-outputs`
16. `runDartFormat()` — `dart format .`

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
│       └── router_module.dart
├── core/
│   ├── di/
│   │   └── core_module.dart         (PackageInfo)
│   ├── domain/
│   │   ├── entities/
│   │   │   └── error_entity.dart    (always generated — not network-only)
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
│   │       ├── type_definitions.dart           (JsonDecodeFactory typedef)
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
packages/
└── clean_router/                    (local workspace package)
```

---

## Dependencies Installed

**Runtime:**
`clean_router` (local path: `packages/clean_router`),
`flutter_bloc`, `go_router`, `get_it`, `injectable`, `freezed_annotation`,
`fpdart`, `slang`, `slang_flutter`, `package_info_plus`, `flutter_svg`,
`json_annotation`, `flutter_localizations` (SDK)

**Dev:**
`build_runner`, `injectable_generator`, `freezed`, `flutter_gen_runner`, `json_serializable`

**Git-hosted (added separately):**
`pretty_dio_logger`, `chucker_flutter`
