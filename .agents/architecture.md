# Architecture of Generated Flutter Projects

## Pattern Overview

```
Feature
├── domain/          Pure Dart — no Flutter, no packages
│   ├── entities/    Abstract classes (no JSON, no annotations)
│   ├── repositories/ Abstract interfaces
│   └── use_cases/   Business logic
│
└── data/            Implements domain contracts
    ├── models/      @freezed classes implementing entities
    ├── datasources/ API calls via Retrofit
    └── repositories/ @LazySingleton implementations
```

---

## Workspace Packages

Every generated project is a **pub workspace** with three local packages:

| Package | Path | Purpose |
|---------|------|---------|
| `clean_router` | `packages/clean_router` | Router base classes shared across features |
| `<app>_utils` | `packages/<app>_utils` | Shared utilities, DI micro-package, network helpers |
| `<app>_localization` | `packages/<app>_localization` | slang config, locale JSON, string extension |

All three are listed under `workspace:` in the root `pubspec.yaml`.
They use `resolution: workspace` so dependency resolution is shared.

---

## Utils Package — `packages/<app>_utils`

Contains everything shared that isn't feature-specific:

```
packages/<app>_utils/
└── lib/
    ├── <app>_utils.dart          (barrel export)
    └── src/
        ├── app_logger.dart
        ├── bloc_observer.dart
        ├── debouncer.dart
        ├── error_entity.dart
        ├── failure.dart
        ├── type_definitions.dart
        ├── di/
        │   ├── <app>_utils_module.dart     (@module — provides BlocObserver, RetrofitLogger)
        │   └── di_initializer.dart         (@InjectableInit.microPackage)
        ├── functions/
        │   ├── get_current_function_name.dart
        │   ├── list_to_model_list.dart
        │   ├── safe_cast.dart
        │   └── safe_execute.dart
        └── network/
            ├── retrofit_call_adapter.dart
            └── retrofit_logger.dart
```

The utils package uses `@InjectableInit.microPackage(preferRelativeImports: true)` to generate
`<App>UtilsPackageModule`, which is referenced in the main app's `@InjectableInit` via
`externalPackageModulesAfter: [.new(<App>UtilsPackageModule)]`.

`BlocObserver` and `RetrofitLogger` are registered by `<App>UtilsModule` (the `@module` class),
**not** annotated directly on the classes.

---

## Localization Package — `packages/<app>_localization`

```
packages/<app>_localization/
├── slang.yaml                          (output_directory: lib/src/generated)
├── assets/locales/en.locale.json
└── lib/
    ├── <app>_localization.dart         (barrel export)
    └── src/
        ├── string_extension.dart       (StringLocaleExtension — String.tr)
        └── generated/
            └── locales.g.dart          (slang output — generated, not committed)
```

`dart run slang` is run inside this package directory during `init`.

---

## Main App Core Structure

```
lib/core/
├── di/
│   └── core_module.dart         (PackageInfo via @preResolve)
├── domain/
│   └── use_cases/
│       └── use_case_base.dart   (abstract UseCase<Type, Params>)
├── data/models/
│   └── error_model.dart         (@freezed, implements ErrorEntity from utils package)
└── network/                     (only present after add-network-module)
    ├── constants/api_paths.dart
    ├── di/network_module.dart   (Dio + interceptors)
    └── interceptors/
        └── error_interceptor.dart
```

`ErrorEntity` and `Failure` live in the utils package and are imported via
`package:<app>_utils/<app>_utils.dart`.

---

## Dependency Injection — get_it + injectable

| Annotation | Meaning |
|------------|---------|
| `@lazySingleton` | Created on first access, shared instance |
| `@LazySingleton(as: X)` | Registered as abstract type X |
| `@Singleton(as: X)` | Eager singleton registered as X |
| `@module` | Provides third-party or platform instances |
| `@preResolve` | Awaited before app starts (e.g. PackageInfo) |
| `@InjectableInit.microPackage` | Marks a package for micro-package DI generation |

`GetIt` instance lives in `lib/app/di/di_container.dart`.
`@InjectableInit` in the main app bootstraps everything via `diInitializer(diContainer)` in `bootstrap.dart`,
with `externalPackageModulesAfter: [.new(<App>UtilsPackageModule)]` to wire in the utils package.

Build runner must run in the **utils package first**, then in the root app, so that
`<App>UtilsPackageModule` exists when the root app's code generation runs.

---

## Routing — go_router + CleanRouterBase

Router base classes live in the local `packages/clean_router` package (workspace member).
Each feature provides a `CleanRouterBase` implementation:

```dart
abstract interface class CleanRouterBase {
  List<RouteBase> get routes;
  List<Stream<dynamic>> get refreshStreams;
  FutureOr<String?> redirect(BuildContext context, GoRouterState state);
  int get priority;    // lower = higher priority
}
```

`CleanRouterRefresh` (also from `clean_router`) is a `ChangeNotifier` that listens to all feature
refresh streams and notifies `GoRouter` to re-evaluate redirects.

`AppRouterModule` collects all `CleanRouterBase` implementations, sorts by `priority`, and builds `AppGoRouter`.
`app_router_module.dart` is **tool-owned** — regenerated by `add-feature`, `remove-feature`, and `regenerate-router`.

---

## State Management — flutter_bloc + freezed

Every feature BLoC:
- Extends `Bloc<FeatureEvent, FeatureState>`
- Is annotated `@lazySingleton` for DI
- Events and states are `@freezed` union types
- Event and state files are `part of` the bloc file

---

## Network — dio + retrofit + error handling

- `Dio` instance provided by `NetworkModule` (`@module`)
- `ErrorInterceptor` parses `{"errors": [...]}` API responses into `ErrorModel`
- `ChuckerDioInterceptor` + `PrettyDioLogger` added in debug builds
- Base URL lives in `lib/core/network/constants/api_paths.dart`
- `RetrofitCallAdapter` (in utils package) wraps Retrofit calls into `Either<Failure, T>`
- `RetrofitLogger` (in utils package) implements `ParseErrorLogger` for Retrofit error logging
- Retrofit datasources use `@RestApi()` — run `build_runner` to generate

---

## Error Handling — fpdart + Failure

All of the following live in `packages/<app>_utils` and are imported via `package:<app>_utils/<app>_utils.dart`:

- `Failure` implements `Exception` with an optional `message`; `Failure.leftFromError(e)` wraps any caught object as `Left<Failure>`
- `ErrorEntity` abstract class with `errors: List<String>`
- `safeCast<T>(data, decoder)` — safely casts dynamic API responses to `Either<Failure, T>`
- `safeExecute<T>(exec)` — wraps any async call in `Either<Failure, T>`
- `JsonDecodeFactory<T>` typedef in `type_definitions.dart`
- `listToModelList<T>(list, decoder)` — converts a list of dynamic values to `List<T>` using a decoder

---

## Serialization — freezed + json_serializable

Data models:
- Are `@freezed sealed class` implementing their domain entity
- Have `fromJson` factory + generated `toJson`
- Require `build_runner` to generate `.freezed.dart` and `.g.dart` files

---

## Localization — slang

- Config: `slang.yaml` lives in `packages/<app>_localization`
- Source: `packages/<app>_localization/assets/locales/en.locale.json`
- Output: `packages/<app>_localization/lib/src/generated/locales.g.dart`
- Initialized in `bootstrap.dart` via `LocaleSettings.useDeviceLocale()`
- Wrapped in `TranslationProvider` in `MainApp`
- `String.tr` extension lives in the localization package; imported via `package:<app>_localization/<app>_localization.dart`

---

## Asset Generation — flutter_gen

- Config: `build.yaml` at project root
- Output: `lib/generated/flutter_gen/`
- Colors sourced from `assets/colors/colors.xml`
- SVG integration enabled
