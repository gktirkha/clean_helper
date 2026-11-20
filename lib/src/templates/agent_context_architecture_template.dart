import '../functions/agent_context/agent_context_info.dart';

/// `.agents/architecture.md`: the generated project's structure, with this
/// project's configured package names.
String agentContextArchitectureTemplate(AgentContextInfo info) {
  final where = info.apps.isEmpty
      ? '`${info.foundationDir}/` (next to `lib/`)'
      : '`${info.foundationDir}/` at the workspace root (or per app, for '
            'packages an app creates itself)';
  final auth = info.auth
      ? ' With the auth interceptor: an abstract `AuthInterceptor` (the app '
            'implements `AppAuthInterceptor`) and a `noAuthDio` for refresh '
            'calls.'
      : '';
  return '''
# Architecture

## App layout

```
lib/
├── main.dart                   calls bootstrap()
├── app/
│   ├── bootstrap.dart          binding, InitService().init(), runApp
│   ├── init_service.dart       locale, DI (environment), Bloc.observer, DioLens
│   ├── main_app.dart           <Theme> → TranslationProvider → MaterialApp.router
│   ├── di/                     di_container.dart (GetIt), di_initializer.dart (@InjectableInit)
│   ├── navigation/             <feature>_navigation_impl.dart
│   └── router/                 <app>_router.dart, <app>_router_redirect.dart, <app>_router_module.dart (tool-owned)
├── core/
│   ├── di/                     core_module.dart (@dev/@prod), test_environment_core_module.dart (@test)
│   ├── theme/app_theme.dart    appTheme(): the app's design tokens
│   ├── data/models/            error_model.dart (backend error body)
│   └── network/                api_paths, call adapter, ApiFailure, NetworkConfigModule, interceptors
├── features/<feature>/         see below
└── generated/                  flutter_gen output — don't edit
```

## Feature layout

```
lib/features/<f>/
├── presentation/
│   ├── bloc/<f>/               <f>_bloc.dart (@injectable), freezed <f>_event / <f>_state
│   ├── page_providers/         BlocProvider + navigation from DI
│   └── pages/                  pure UI
├── router/                     <f>_routes.dart, <f>_navigation.dart (interface), <f>_router.dart
├── domain/                     entities, repository interfaces, params, use cases — no Flutter
└── data/                       models (@freezed), datasources (Retrofit), repository implementations
```

Data flows `page → bloc → use case → repository → datasource`, as
`TaskEither<Failure, T>`.

## Foundation packages

Workspace packages in $where. None depends on another.

| Package | Contents |
|---|---|
| `${info.utils}` | `Failure`, `UseCaseBase`, `AppLogger`, `ContextUtils`, `safeCast`, `safeExecute`, `safeExecuteTask`, `Debouncer`; micro-package DI module |
| `${info.localization}` | slang translations, `String.tr` |
| `${info.router}` | the router interface every feature router implements, and the refresh notifier |
| `${info.theme}` | design tokens (`…ThemeData`, `AdaptiveColor`), the theme widget above `MaterialApp`, `ThemeResolver` |
| `${info.network}` | `NetworkConfig`, Dio instances (named `BaseOptions`, `noBaseOptionsDio`), `RetrofitLogger`; micro-package DI module.$auth |

API errors are turned into failures by the app's call adapter
(`${info.callAdapter}`), not by an interceptor.

## DI and environments

`diInitializer(getIt, environment:)` registers untagged registrations plus
those tagged with the environment (`dev`, `prod`, `test`).
`InitService.init` uses `prod` in release builds and `dev` otherwise. Tests
start DI with `Environment.test` (import injectable with
`show Environment`; its `@test` clashes with `flutter_test`).

## Recommended monorepo layering

clean-helper only generates the foundation packages and the apps; this is
the suggested way to grow beyond them. Dependencies only point down.

| Layer | Level | May depend on | Examples |
|---|---|---|---|
| `foundation/` | 1 | Primitives only, no other workspace packages | theme, utils, network, localization, router |
| `core/` | 2 | `foundation/` only, no siblings | ui (theme + l10n), data (network + utils) |
| `features/` | 3 | Anything below, plus other features | menu, cart, auth |
| `apps/` | 4 | Anything below; no app → app | consumer, restaurant, rider |
''';
}
