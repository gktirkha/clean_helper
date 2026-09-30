# Generated Project Structure

A guide to the Flutter project that `clean-helper init` and the other commands produce: where things live, how they fit together, and what to run after changing them. For installing and running the tool itself, see [README.md](README.md).

---

## Directory layout

After `clean-helper init --network`, plus `add-feature <f>` and `add-repo <f> <r> --add-sample`:

```
<app>/
├── lib/
│   ├── main.dart                          calls bootstrap()
│   ├── app/
│   │   ├── bootstrap.dart                 startup — see Startup flow
│   │   ├── main_app.dart                  TranslationProvider → MaterialApp.router
│   │   ├── di/
│   │   │   ├── di_container.dart          final GetIt diContainer = GetIt.instance
│   │   │   ├── di_initializer.dart        @InjectableInit, includes the utils micro-package
│   │   │   └── app_module.dart            navigator key, scaffold messenger key
│   │   ├── navigation/                    <f>_navigation_impl.dart — one per feature
│   │   └── router/
│   │       ├── app_go_router.dart         GoRouter built from every feature router
│   │       ├── app_go_router_redirect.dart
│   │       └── app_router_module.dart     GENERATED — don't edit
│   ├── core/
│   │   ├── di/
│   │   │   ├── core_module.dart           @preResolve PackageInfo
│   │   │   └── di_keys.dart               DIKeys — names for @Named registrations
│   │   ├── domain/use_cases/use_case_base.dart
│   │   ├── data/models/error_model.dart   @freezed, implements ErrorEntity
│   │   └── network/
│   │       ├── constants/api_paths.dart   ApiPaths.baseUrl — set this
│   │       ├── di/network_module.dart     Dio, interceptors, ParseErrorLogger
│   │       ├── interceptors/error_interceptor.dart   (+ auth_interceptor.dart)
│   │       └── utils/
│   │           ├── retrofit_call_adapter.dart   Retrofit call → TaskEither<Failure, T>
│   │           └── retrofit_logger.dart         logs Retrofit parse errors
│   ├── features/<f>/                      see Feature layout
│   └── generated/flutter_gen/             assets.gen.dart, colors.gen.dart
├── packages/
│   ├── clean_router/                      CleanRouterBase, CleanRouterRefresh
│   ├── <app>_localization/                slang config, locale JSON, String.tr
│   └── <app>_utils/                       Failure, AppLogger, safeExecuteTask, …
├── assets/colors/colors.xml               source for ColorName in colors.gen.dart
├── build.yaml                             flutter_gen config
└── pubspec.yaml                           workspace: lists the three packages
```

## Feature layout

```
lib/features/<f>/
├── presentation/
│   ├── page_providers/<f>_page_provider.dart   entry point used by the router
│   ├── pages/<f>_page.dart                     UI
│   └── bloc/<f>/<f>_bloc.dart, <f>_event.dart, <f>_state.dart
├── router/
│   ├── <f>_routes.dart                         route path constants
│   ├── <f>_navigation.dart                     what other code may ask this feature to do
│   └── <f>_router.dart                         go_router routes, redirect, refresh streams, priority
├── domain/                                     pure Dart — no Flutter imports
│   ├── entities/<r>_entity.dart
│   ├── repositories/<r>_repository.dart        interface
│   ├── params/                                 use-case inputs
│   └── use_cases/
└── data/
    ├── constants/<f>_api_paths.dart            endpoint paths
    ├── datasources/<r>_data_source_base.dart   interface
    ├── datasources/rest_<r>_data_source.dart   Retrofit implementation
    ├── models/requests/, models/response/      JSON models
    └── repositories/<r>_repository_impl.dart
```

Dependencies point inwards: presentation → domain ← data. The domain layer knows nothing about Dio, Retrofit or Flutter.

---

## Startup flow

```
main()
 └── bootstrap()
       ├── WidgetsFlutterBinding.ensureInitialized()
       ├── LocaleSettings.useDeviceLocale()
       ├── Debouncer.showLogs = kDebugMode
       ├── await diInitializer(diContainer)      registers everything, awaits @preResolve
       ├── Bloc.observer = diContainer()         AppBlocObserver from the utils package
       └── runApp(MainApp)
             └── TranslationProvider
                   └── MaterialApp.router(routerConfig: AppGoRouter)
```

---

## Dependency injection

`get_it` + `injectable`. Resolve anything with `diContainer<T>()`, or `diContainer()` where the type is inferred.

| What | Annotation | Lifetime |
|---|---|---|
| Feature bloc | `@injectable` | New instance each time — `BlocProvider` closes it on dispose |
| Feature router, navigation impl | `@lazySingleton`, `@LazySingleton(as: <F>Navigation)` | One instance, created on first use |
| Repository impl | `@Singleton(as: <R>Repository)` | One instance, created at startup |
| REST datasource | `@Injectable(as: <R>DataSourceBase)` | New instance each time |
| Third-party objects | methods on a `@module` class (`NetworkModule`, `CoreModule`, `AppModule`) | As annotated |
| Async setup | `@preResolve` | Awaited in `diInitializer` |

The utils package is an injectable micro-package: build_runner generates `<App>UtilsPackageModule` there, and the app includes it through `externalPackageModulesAfter`. So build_runner must run in `packages/<app>_utils` before the app.

Run build_runner after any annotation change.

---

## Routing

go_router, with one router per feature, all implementing `CleanRouterBase` from `packages/clean_router`:

```dart
abstract interface class CleanRouterBase {
  List<RouteBase> get routes;
  List<Stream<dynamic>> get refreshStreams;   // emit to re-run redirects
  FutureOr<String?> redirect(BuildContext context, GoRouterState state);
  int get priority;                           // lower = earlier
}
```

`AppRouterModule` receives every feature router from DI, sorts them by `priority`, and builds `AppGoRouter`. `CleanRouterRefresh` merges all `refreshStreams` into go_router's `refreshListenable`.

`app_router_module.dart` is **generated**. `add-feature`, `remove-feature` and `regenerate-router` rewrite it with features in alphabetical order. Don't edit it by hand.

Route paths live in `<F>Routes` — `sign_up` becomes `SignUpRoutes.signUp = '/sign-up'`.

### Navigating between features

Pages never import another feature's routes. Each feature declares what it can do in `<F>Navigation`, and the app implements that in `lib/app/navigation/<f>_navigation_impl.dart` with `context.go(...)`. Pages receive their navigation object as a constructor argument.

---

## Page provider and page

| File | Role |
|---|---|
| `page_providers/<f>_page_provider.dart` | What the router builds. Creates the bloc with `BlocProvider(create: (_) => diContainer())` and passes `navigation: diContainer()` to the page. |
| `pages/<f>_page.dart` | Pure UI. Gets the bloc from context and navigation from its constructor, with no DI calls — which keeps it easy to test and preview. |

---

## State management

`flutter_bloc` + `freezed`. Each bloc extends `Bloc<<F>Event, <F>State>`. Its events and states are `@freezed` unions in `part` files of the bloc, and one `_handleEvents` handler dispatches with `event.when(...)`.

Run build_runner after adding or changing events or states.

---

## Errors and results

The API chain returns fpdart's `TaskEither<Failure, T>`:

```
REST datasource  →  repository  →  use case  →  bloc
TaskEither<Failure, <R>ResponseModel>  →  TaskEither<Failure, <R>Entity>  →  await …run()
```

A `TaskEither` is lazy. Nothing happens until `.run()`, which returns `Future<Either<Failure, T>>`, and before that you can combine steps with `map`, `flatMap` and `orElse`:

```dart
final result = await getOrderUseCase(params).run();
result.fold(
  (failure) => emit(.error(failure.message)),
  (order) => emit(.loaded(order)),
);
```

Retrofit calls go through `RetrofitCallAdapter`, which wraps them with `safeExecuteTask`, so network and parsing errors arrive as `Left(Failure)` instead of exceptions.

Projects set up before 1.4.2 use `Future<Either<Failure, T>>` instead. `result_type: future_either` keeps `add-repo` generating that style.

| Utility (utils package) | Purpose |
|---|---|
| `Failure` | Exception with an optional `message`. `Failure.leftFromError(e)` → `Left<Failure>` |
| `safeExecuteTask(() => future)` | Lazy `TaskEither<Failure, T>`; errors are logged and become `Failure` |
| `safeExecute(future)` | Eager `Either<Failure, T>` |
| `safeCast<T>(data, decoder)` | Dynamic API data → `Either<Failure, T>`. Handles null, `ErrorEntity`, an existing `T`, a JSON string and a `Map` |
| `listToModelList<T>(list, decoder)` | JSON array → `List<T>` |
| `UseCaseBase<Return, Params>` | Use-case base (in `lib/core/domain/use_cases/`). `call` returns `FutureOr<TaskEither<…>>`. Use `Unit` for no params |

---

## Network

`dio` + `retrofit`. `NetworkModule` provides:

- `BaseOptions` — `ApiPaths.baseUrl`, timeouts, and a `User-Agent` built from `PackageInfo`;
- `Dio` — with `ErrorInterceptor`, `ChuckerDioInterceptor` (in-app request inspector) and `PrettyDioLogger`;
- `ParseErrorLogger` — `RetrofitLogger`, which Retrofit datasources receive.

`ErrorInterceptor` turns `{"errors": [...]}` responses into `ErrorModel`.

To add an endpoint:

1. Add a path to `<F>ApiPaths`.
2. Declare an `@GET`/`@POST`/… method in `Rest<R>DataSource` and in `<R>DataSourceBase`.
3. Run build_runner.

With `add-auth-interceptor`, `AuthInterceptor` adds the bearer token and refreshes it on 401, using a separate `@Named(DIKeys.noAuthDio)` Dio for the refresh call. Fill in its TODOs to connect your token storage and refresh endpoint.

---

## Localization

slang, in `packages/<app>_localization`. Strings live in `assets/locales/en.locale.json` there. After editing them, run `clean-helper bootstrap`, or `dart run slang` inside that package.

```dart
locales.general.somethingWentWrong          // top-level accessor
context.t.general.somethingWentWrong        // via TranslationProvider
'general.somethingWentWrong'.tr             // String extension
```

---

## Logging

`AppLogger`, from the utils package, is a static wrapper around a `Logger` from the `logger` package:

```dart
AppLogger.debug('message');
AppLogger.info('message');
AppLogger.warning('message');
AppLogger.error('message', error: e, stackTrace: s, time: DateTime.now());
```

`AppBlocObserver` logs bloc activity, and `RetrofitLogger` logs response-parsing failures.

---

## Import conventions

- Inside the app, use **relative imports**, never `package:<app>/…`.
- Use `package:` imports for other packages, including the workspace packages (`package:<app>_utils/<app>_utils.dart`).
- Keep imports sorted: `dart:`, then `package:`, then relative, each alphabetical.

---

## Code generation

Run build_runner after changing anything annotated with `@freezed`, `@JsonSerializable`, `@injectable` / `@module`, or `@RestApi`, or after changing assets and colours:

```bash
clean-helper build-runner            # build
clean-helper build-runner clean      # remove stale outputs first, then build again
```

The generated files (`*.g.dart`, `*.freezed.dart`, `*.config.dart`, `*.module.dart`, `lib/generated/`) aren't meant to be edited.
