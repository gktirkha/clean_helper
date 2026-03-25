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
6. `generateCoreFiles(packageName)` — all core Dart files (main, bootstrap, DI, routing)
7. `generateNetworkFiles()` — Dio, error interceptor, network module
8. `generateHomeFeature(packageName)` — complete home feature scaffold
9. `installDependencies()` — `dart pub add` / `flutter pub add`
10. `addChuckerDependency()` — git-hosted chucker_flutter
11. `addFlutterAssetsToPubSpec()` — patches `pubspec.yaml` flutter.assets
12. `runSlang()` — `dart run slang`
13. `runBuildRunner()` — `dart run build_runner build --delete-conflicting-outputs`
14. `runDartFormat()` — `dart format .`

---

## Generated Structure in Target Project

```
lib/
├── main.dart
├── app/
│   ├── bootstrap.dart
│   ├── main_app.dart
│   ├── navigations/
│   │   └── home_navigation_impl.dart
│   └── router/
│       ├── app_go_router.dart
│       └── router_module.dart
├── core/
│   ├── di/
│   │   ├── di_container.dart        (GetIt instance)
│   │   ├── di_initializer.dart      (@InjectableInit)
│   │   ├── core_module.dart         (nav keys, PackageInfo)
│   │   └── di_keys.dart
│   ├── router/
│   │   ├── router_base.dart         (abstract interface RouterBase)
│   │   └── router_refresh.dart      (GoRouterRefreshStream)
│   ├── network/
│   │   ├── constants/api_paths.dart
│   │   ├── di/network_module.dart   (Dio + interceptors)
│   │   └── interceptors/error_interceptor.dart
│   ├── data/models/error_model.dart
│   ├── domain/entities/error_entity.dart
│   └── generated/
│       ├── locales/                 (slang output)
│       └── flutter_gen/             (flutter_gen output)
└── features/
    └── home/
        ├── di/
        │   └── home_module.dart     (@module abstract class HomeModule)
        └── ...                      (see add_feature.md for full structure)
assets/
├── locales/en.locale.json
└── colors/colors.xml
build.yaml
slang.yaml
analysis_options.yaml               (overwritten with project standard)
```

---

## Dependencies Installed

**Runtime:**
`flutter_bloc`, `go_router`, `get_it`, `injectable`, `freezed_annotation`,
`fpdart`, `slang`, `slang_flutter`, `dio`, `retrofit`, `json_annotation`,
`package_info_plus`, `flutter_svg`, `pretty_dio_logger` (git), `chucker_flutter` (git),
`flutter_localizations` (SDK)

**Dev:**
`build_runner`, `injectable_generator`, `freezed`, `retrofit_generator`,
`json_serializable`, `flutter_gen_runner`
