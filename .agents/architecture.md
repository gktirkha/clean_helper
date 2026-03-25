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

## Dependency Injection — get_it + injectable

| Annotation | Meaning |
|------------|---------|
| `@lazySingleton` | Created on first access, shared instance |
| `@LazySingleton(as: X)` | Registered as abstract type X |
| `@Singleton(as: X)` | Eager singleton registered as X |
| `@module` | Provides third-party or platform instances |
| `@preResolve` | Awaited before app starts (e.g. PackageInfo) |

`GetIt` instance lives in `lib/app/di/di_container.dart`.
`@InjectableInit` bootstraps everything via `diInitializer(diContainer)` in `bootstrap.dart`.

---

## Routing — go_router + RouterBase

Each feature provides a `RouterBase` implementation:

```dart
abstract interface class RouterBase {
  List<RouteBase> get routes;
  List<Stream<dynamic>> get refreshStreams;
  FutureOr<String?> redirect(BuildContext context, GoRouterState state);
  int get priority;    // lower = higher priority
}
```

`RouterModule` collects all `RouterBase` implementations, sorts by `priority`, and builds `AppGoRouter`.
To add a new feature's routes, inject its router into `RouterModule`.

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
- Retrofit datasources use `@RestApi()` — run `build_runner` to generate

---

## Serialization — freezed + json_serializable

Data models:
- Are `@freezed sealed class` implementing their domain entity
- Have `fromJson` factory + generated `toJson`
- Require `build_runner` to generate `.freezed.dart` and `.g.dart` files

---

## Localization — slang

- Config: `slang.yaml` at project root
- Source: `assets/locales/en.locale.json`
- Output: `lib/generated/locales/locales.g.dart`
- Initialized in `bootstrap.dart` via `LocaleSettings.useDeviceLocale()`
- Wrapped in `TranslationProvider` in `MainApp`

---

## Asset Generation — flutter_gen

- Config: `build.yaml` at project root
- Output: `lib/generated/flutter_gen/`
- Colors sourced from `assets/colors/colors.xml`
- SVG integration enabled
