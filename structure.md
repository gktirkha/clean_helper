# Generated Project Structure

This document describes the Flutter project produced by `clean-helper init` and subsequent commands.

---

## Directory Layout

```
lib/
├── main.dart
├── app/
│   ├── bootstrap.dart
│   ├── main_app.dart
│   ├── di/
│   │   ├── di_container.dart           GetIt instance
│   │   ├── di_initializer.dart         @InjectableInit bootstrap
│   │   ├── di_keys.dart                Named DI string constants (sealed class)
│   │   └── app_module.dart             NavigatorKey + ScaffoldMessengerKey
│   ├── navigations/
│   │   └── <feature>_navigation_impl.dart   @LazySingleton(as: FeatureNavigation)
│   └── router/
│       ├── app_go_router.dart
│       ├── app_go_router_redirect.dart
│       └── app_router_module.dart      ← tool-owned, do not edit
├── core/
│   ├── di/
│   │   └── core_module.dart            PackageInfo (@preResolve), Logger
│   ├── domain/
│   │   ├── entities/
│   │   │   └── error_entity.dart       abstract class with errors: List<String>
│   │   ├── failures/
│   │   │   └── failure.dart            Failure + leftFromError<T>
│   │   └── use_cases/
│   │       └── use_case_base.dart      UseCaseBase<ReturnType, ParameterType>
│   ├── data/
│   │   └── models/
│   │       └── error_model.dart        @freezed, implements ErrorEntity
│   ├── network/
│   │   ├── constants/
│   │   │   └── api_paths.dart          sealed class ApiPaths { baseUrl }
│   │   ├── di/
│   │   │   └── network_module.dart     Dio + interceptors
│   │   └── interceptors/
│   │       ├── error_interceptor.dart
│   │       └── auth_interceptor.dart   (only with add_auth_interceptor)
│   └── utils/
│       ├── extensions/
│       │   └── string_extension.dart   String.tr shorthand
│       └── functions/
│           ├── app_logger.dart         Static logging facade
│           ├── debouncer.dart
│           ├── get_current_function_name.dart
│           ├── type_definitions.dart   JsonDecodeFactory typedef
│           ├── safe_cast.dart          Either<Failure, T> from dynamic
│           ├── safe_execute.dart       Either<Failure, T> from async call
│           └── list_to_model_list.dart List<T> from raw JSON array
├── features/
│   └── <feature>/                      one folder per feature
│       ├── data/
│       │   ├── constants/
│       │   │   └── <feature>_api_paths.dart
│       │   ├── datasources/
│       │   │   ├── <repo>_data_source_base.dart   abstract interface
│       │   │   └── rest_<repo>_data_source.dart   @RestApi Retrofit impl
│       │   ├── models/
│       │   │   ├── requests/
│       │   │   │   └── <repo>_request_model.dart  @JsonSerializable
│       │   │   └── response/
│       │   │       └── <repo>_response_model.dart @freezed + implements entity
│       │   └── repositories/
│       │       └── <repo>_repository_impl.dart    @Singleton(as: AbstractRepo)
│       ├── di/                         (only with --di flag on add_feature)
│       │   └── <feature>_module.dart   @module abstract class
│       ├── domain/
│       │   ├── entities/
│       │   │   └── <repo>_entity.dart  abstract class, no annotations
│       │   ├── repositories/
│       │   │   └── <repo>_repository.dart  abstract interface
│       │   └── use_cases/              add use cases here manually
│       ├── presentation/
│       │   ├── bloc/<feature>/
│       │   │   ├── <feature>_bloc.dart    @lazySingleton, extends Bloc
│       │   │   ├── <feature>_event.dart   part of bloc, @freezed
│       │   │   └── <feature>_state.dart   part of bloc, @freezed
│       │   ├── pages/
│       │   │   └── <feature>_page.dart    pure UI, receives navigation as param
│       │   ├── screens/
│       │   │   └── <feature>_screen.dart  BlocProvider + DI wiring, used by router
│       │   └── widgets/
│       └── router/
│           ├── <feature>_navigation.dart  abstract class FeatureNavigation
│           ├── <feature>_router.dart      @lazySingleton, implements CleanRouterBase
│           └── <feature>_routes.dart      sealed class FeatureRoutes { path constants }
└── generated/
    ├── locales/
    │   └── locales.g.dart              slang output — do not edit
    └── flutter_gen/                    flutter_gen output — do not edit

assets/
├── locales/
│   └── en.locale.json                  localization source strings
└── colors/
    └── colors.xml                      color definitions for flutter_gen

packages/
└── clean_router/                       local workspace package
    └── lib/
        └── clean_router.dart           exports CleanRouterBase + CleanRouterRefresh

tools/
├── command_runner.dart                 shared Process.start helper
├── clean.dart                          build_runner clean + flutter clean + git clean
├── bootstrap.dart                      pub get + slang + build_runner
├── write_key_properties.dart           writes android/key.properties from config
└── build_android.dart                  signs + builds AAB/APK

build.yaml
slang.yaml
analysis_options.yaml
```

---

## Startup Flow

```
main()
 └── bootstrap()
       ├── WidgetsFlutterBinding.ensureInitialized()
       ├── LocaleSettings.useDeviceLocale()
       ├── Debouncer.showLogs = kDebugMode
       ├── await diInitializer(diContainer)
       └── runApp(MainApp)
                └── TranslationProvider
                      └── MaterialApp.router
                            └── diContainer<AppGoRouter>().router
```

---

## Dependency Injection

Uses `get_it` + `injectable`. The DI container is the global `diContainer` instance in `lib/app/di/di_container.dart`.

| Annotation | Meaning |
|------------|---------|
| `@lazySingleton` | Created on first access, shared instance |
| `@LazySingleton(as: X)` | Registered as abstract type `X` |
| `@Singleton(as: X)` | Eager singleton registered as `X` |
| `@module` | Provides third-party / platform instances |
| `@preResolve` | Awaited before the app starts (e.g. `PackageInfo`) |
| `@Injectable(as: X)` | Transient, registered as `X` |

Run `build_runner` after any DI annotation change.

---

## Routing

Uses `go_router` and the local `clean_router` package.

Every feature provides a `@lazySingleton` class implementing `CleanRouterBase`:

```dart
abstract interface class CleanRouterBase {
  List<RouteBase> get routes;
  List<Stream<dynamic>> get refreshStreams;
  FutureOr<String?> redirect(BuildContext context, GoRouterState state);
  int get priority;   // lower = evaluated first
}
```

`AppRouterModule` collects all `CleanRouterBase` implementations via injectable, sorts by `priority`, and builds `AppGoRouter`.

`app_router_module.dart` is **tool-owned** — regenerated by `add_feature`, `remove_feature`, and `regenerate_router`. Do not edit it manually.

Navigation between features is done through abstract `FeatureNavigation` interfaces injected into pages. The implementations live in `lib/app/navigations/` and use `context.go()`.

---

## Screen / Page Pattern

Every feature has two presentation entry points:

| File | Role |
|------|------|
| `screens/<feature>_screen.dart` | Provides `BlocProvider` and resolves `navigation` from DI. Used directly by the router. |
| `pages/<feature>_page.dart` | Pure UI widget. Receives `navigation` as a constructor parameter. No DI knowledge. |

---

## State Management

Uses `flutter_bloc` + `freezed`. Each feature BLoC:

- Extends `Bloc<FeatureEvent, FeatureState>`
- Is annotated `@lazySingleton` for DI
- Has `@freezed` event and state union types declared as `part of` the bloc file

Run `build_runner` after adding or removing events/states.

---

## Error Handling

Uses `fpdart`. All repository and use-case return types are `Either<Failure, T>` or `FutureOr<Either<Failure, T>>`.

| Utility | Purpose |
|---------|---------|
| `Failure` | Wraps any error with an optional `message`. `Failure.leftFromError(e)` turns any caught object into `Left<Failure>`. |
| `safeCast<T>(data, decoder)` | Converts a dynamic API response to `Either<Failure, T>`. Handles null, `ErrorEntity`, already-`T`, JSON string, and `Map`. |
| `safeExecute<T>(exec)` | Wraps any async call in `Either<Failure, T>`. |
| `listToModelList<T>(list, decoder)` | Converts a raw JSON array to `List<T>`. |
| `UseCaseBase<ReturnType, ParameterType>` | Base class for use cases. Use `Unit` for no params, `void` for no return. |

---

## Network Layer

Uses `dio` + `retrofit`. `NetworkModule` provides:

- `BaseOptions` — base URL, timeouts, `User-Agent` header
- `Dio` — with `ErrorInterceptor`, `ChuckerDioInterceptor` (in-app inspector), `PrettyDioLogger`

Set the base URL in `lib/core/network/constants/api_paths.dart`.

Retrofit datasources annotated with `@RestApi()` require `build_runner` to generate the implementation.

When `add_auth_interceptor` is used, `AuthInterceptor` is wired into the Dio interceptor chain. It handles token attachment and automatic token refresh on 401. Fill in the TODOs in `auth_interceptor.dart` to connect your token storage.

---

## Localization

Uses `slang`. Source strings live in `assets/locales/en.locale.json`. Run `clean-helper generate_localizations` (or `dart run slang`) after editing them.

Access strings via the `locales` top-level accessor or `context.t`:

```dart
locales.general.somethingWentWrong
context.t.general.somethingWentWrong
```

---

## Logging

`AppLogger` is a static facade over a DI-provided `Logger` instance:

```dart
AppLogger.trace(...)
AppLogger.debug(...)
AppLogger.info(...)
AppLogger.warning(...)
AppLogger.error('tag', error: e, stackTrace: s, time: DateTime.now())
```

---

## Import Rules

- Files within the same feature use **relative imports only** — no `package:<app>` imports.
- `package:` imports are only for external packages.

---

## Code Generation

Any change to `@freezed`, `@injectable`, or `@RestApi` classes requires:

```bash
clean-helper build_runner
```

To clean stale files first:

```bash
clean-helper build_runner clean
clean-helper build_runner
```
