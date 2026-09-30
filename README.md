# clean_helper

A Dart CLI that scaffolds Flutter apps in **Clean Architecture** and keeps generating code in the same shape as the app grows: features, repositories, entities, routing, DI, BLoC and the network layer.

It works in a single Flutter app and in a pub-workspace monorepo with several apps and shared packages.

---

## Contents

- [Installation](#installation)
- [Quick start](#quick-start)
- [Commands](#commands)
- [Configuration (`clean-helper` in pubspec.yaml)](#configuration)
- [Monorepos](#monorepos)
- [What gets generated](#what-gets-generated)
- [Using the generated code](#using-the-generated-code)
- [Upgrading existing projects](#upgrading-existing-projects)
- [Requirements](#requirements)

---

## Installation

```bash
dart pub global activate --source git https://github.com/gktirkha/clean_helper
```

From a local checkout:

```bash
dart pub global activate --source path /path/to/clean_helper
```

A path activation runs a compiled snapshot. After changing the source or bumping the version, run the activate command again so `clean-helper` picks it up.

Check the installed version:

```bash
clean-helper --version
```

Shell completion (one-off):

```bash
clean-helper install-completion-files
```

---

## Quick start

```bash
flutter create my_app && cd my_app
clean-helper init --network                        # full scaffold + network layer
clean-helper add-feature orders                    # routing, bloc and page for a feature
clean-helper add-repo orders order --add-sample    # data layer with sample GET/POST
```

`dart format` and `build_runner` run automatically after each generating command.

If [fvm](https://fvm.app) is installed, every `dart`/`flutter` call goes through it, and `init` / `bootstrap` start with `fvm use`.

---

## Commands

Global options go **before** the command:

| Option | Description |
|---|---|
| `--scope=<app>` | In a monorepo, pick the app by folder name instead of being prompted |
| `--version` | Print the clean-helper version and exit |
| `-h`, `--help` | Show help |

| Command | Description |
|---|---|
| [`init`](#init) | Full project scaffold — run once on a new Flutter project |
| [`bootstrap`](#bootstrap) | `pub get` → slang → build_runner |
| [`add-feature <name>`](#add-feature) | New feature: routes, router, navigation, bloc, page |
| [`add-repo <feature> <name>`](#add-repo) | Data + domain layer for a repository |
| [`add-entity <scope> <name> [folder]`](#add-entity) | Domain entity + freezed model |
| [`add-network-module`](#add-network-module) | Dio + Retrofit network layer |
| [`add-auth-interceptor`](#add-auth-interceptor) | Token-refreshing auth interceptor |
| [`remove-feature <name>`](#remove-feature) | Delete a feature and unregister its router |
| [`regenerate-router`](#regenerate-router) | Rebuild `app_router_module.dart` from the features on disk |
| [`build-runner [build\|clean]`](#build-runner) | Run build_runner |
| [`generate-localizations`](#generate-localizations) | Run slang |
| [`generate-tools [--overwrite]`](#generate-tools) | Generate `tools/` scripts |
| [`add-vscode-config`](#add-vscode-config) | Generate `.vscode/` files |
| [`list-mono-repo-apps`](#list-mono-repo-apps) | Show the resolved monorepo and package config |

### `init`

```bash
clean-helper init [--network] [--auth-interceptor] [--di] [--tools]
```

| Flag | Short | Effect |
|---|---|---|
| `--network` | `-n` | Also run `add-network-module` |
| `--auth-interceptor` | `-a` | Also run `add-auth-interceptor` (implies `--network`) |
| `--di` | `-d` | Also generate a DI module for the `home` feature |
| `--tools` | `-t` | Also generate the `tools/` scripts |

What it does:

1. Writes `analysis_options.yaml` and runs `flutter pub get`.
2. Creates three workspace packages under `packages/`: `clean_router`, `<app>_localization` and `<app>_utils` (see [Workspace packages](#workspace-packages)), and adds them to `workspace:` in `pubspec.yaml`.
3. Generates the app skeleton: `main.dart`, `bootstrap.dart`, `MainApp`, go_router setup, get_it/injectable DI, `UseCaseBase`, and a `home` feature.
4. Installs dependencies, updates `.gitignore`, adds `.vscode/` config and flutter_gen setup (`build.yaml`, `assets/colors/colors.xml`).
5. Optionally adds the network layer, auth interceptor and tools.
6. Runs slang, then build_runner in the utils package and in the app, then `dart format`.
7. Sorts dependencies in every pubspec and stamps `clean-helper.version` in `pubspec.yaml`.

Dependencies installed in the app:

- **Runtime:** `flutter_bloc`, `go_router`, `get_it`, `injectable`, `freezed_annotation`, `fpdart`, `package_info_plus`, `flutter_svg`, `json_annotation`, `logger`, `flutter_localizations` (SDK)
- **Dev:** `build_runner`, `injectable_generator`, `freezed`, `flutter_gen_runner`, `json_serializable`
- **Path:** `clean_router`, `<app>_localization`, `<app>_utils`

### `bootstrap`

```bash
clean-helper bootstrap
```

Runs `fvm use` (if fvm is installed), `flutter pub get`, slang in `packages/<app>_localization`, then `build_runner build` in the app. Use it after a `git pull` that changed dependencies or generated inputs.

### `add-feature`

```bash
clean-helper add-feature user_profile [--di]
```

The name must be **snake_case**. It is used as-is for paths, as PascalCase for classes, camelCase for identifiers and kebab-case for the route path — `user_profile` gives `UserProfileRoutes.userProfile = '/user-profile'`.

```
lib/
├── app/navigation/
│   └── user_profile_navigation_impl.dart        @LazySingleton(as: UserProfileNavigation)
└── features/user_profile/
    ├── di/user_profile_module.dart              only with --di
    ├── presentation/
    │   ├── bloc/user_profile/
    │   │   ├── user_profile_bloc.dart           @injectable, extends Bloc
    │   │   ├── user_profile_event.dart          part of the bloc, @freezed
    │   │   └── user_profile_state.dart          part of the bloc, @freezed
    │   ├── page_providers/
    │   │   └── user_profile_page_provider.dart  BlocProvider + navigation from DI
    │   └── pages/
    │       └── user_profile_page.dart           pure UI, takes navigation as a parameter
    └── router/
        ├── user_profile_routes.dart             route path constants
        ├── user_profile_navigation.dart         navigation interface
        └── user_profile_router.dart             @lazySingleton, implements CleanRouterBase
```

The router is registered in `lib/app/router/app_router_module.dart` automatically. That file is tool-owned: `add-feature`, `remove-feature` and `regenerate-router` regenerate it, with features in alphabetical order.

The bloc is `@injectable` (a new instance per page) because `BlocProvider` closes it when the page is disposed.

### `add-repo`

```bash
clean-helper add-repo <feature> <repo_name> [--add-sample] [--no-rest]
```

| Flag | Effect |
|---|---|
| `--add-sample` | Adds sample `get<Name>` / `post<Name>` methods at every layer, plus request/response models, params and use cases |
| `--no-rest` | Skips the Retrofit datasource and API paths |

`clean-helper add-repo orders order --add-sample` generates:

```
lib/features/orders/
├── domain/
│   ├── entities/order_entity.dart
│   ├── repositories/order_repository.dart            abstract interface
│   ├── params/get_order_params.dart                  --add-sample
│   ├── params/post_order_params.dart                 --add-sample
│   ├── use_cases/get_order_use_case.dart             --add-sample
│   └── use_cases/post_order_use_case.dart            --add-sample
└── data/
    ├── constants/orders_api_paths.dart               REST only
    ├── datasources/order_data_source_base.dart       abstract interface
    ├── datasources/rest_order_data_source.dart       REST only — @RestApi, @Injectable
    ├── models/requests/order_request_model.dart      --add-sample
    ├── models/response/order_response_model.dart     --add-sample — @freezed, implements OrderEntity
    └── repositories/order_repository_impl.dart       @Singleton(as: OrderRepository)
```

- The API chain returns `TaskEither<Failure, T>` (see [`result_type`](#result_type)).
- REST files are generated only when a network module exists — `lib/core/network/di/network_module.dart`, or a configured [`packages.network`](#packagesnetwork) — and `--no-rest` isn't passed.
- If the app's pubspec lacks `dio`, `retrofit` or `retrofit_generator`, a warning is printed.
- Files that already exist are never overwritten. In particular, adding a second repo to a feature doesn't add its constant to the existing `<feature>_api_paths.dart` — add it by hand.

### `add-entity`

```bash
clean-helper add-entity home invoice            # feature scope
clean-helper add-entity home invoice requests   # model in data/models/requests/
clean-helper add-entity core error              # lib/core/ scope
```

Generates `domain/entities/<name>_entity.dart` (an abstract class) and `data/models/[<folder>/]<name>_model.dart` (a `@freezed` class implementing the entity, with `fromJson`).

### `add-network-module`

```bash
clean-helper add-network-module
```

Generates:

| File | Contents |
|---|---|
| `lib/core/network/constants/api_paths.dart` | `ApiPaths.baseUrl` |
| `lib/core/network/di/network_module.dart` | `@module` providing `Dio` (error, Chucker and pretty-log interceptors) and registering `RetrofitLogger` as `ParseErrorLogger` |
| `lib/core/network/interceptors/error_interceptor.dart` | Parses `{"errors": [...]}` responses into `ErrorModel` |
| `lib/core/network/utils/retrofit_call_adapter.dart` | `RetrofitCallAdapter` — adapts Retrofit calls to `TaskEither<Failure, T>` |
| `lib/core/network/utils/retrofit_logger.dart` | `RetrofitLogger` — logs Retrofit parse errors |
| `lib/core/data/models/error_model.dart` | `@freezed` `ErrorModel` implementing `ErrorEntity` |

It then installs `dio`, `retrofit`, `json_annotation`, `pretty_dio_logger` and `chucker_flutter` (plus dev `retrofit_generator` and `json_serializable`), adds `ChuckerFlutter.navigatorObserver` to `AppGoRouter`, formats and runs build_runner. Existing files are skipped.

### `add-auth-interceptor`

```bash
clean-helper add-auth-interceptor
```

Run after `add-network-module`. Generates `lib/core/network/interceptors/auth_interceptor.dart`, which attaches a bearer token, refreshes it on 401 (de-duplicating concurrent refreshes) and retries the request. It also adds `DIKeys.noAuthDio` and wires into `NetworkModule` both `AuthInterceptor` and a `@Named(DIKeys.noAuthDio)` Dio without it, used for the refresh call. Fill in the TODOs for token storage and the refresh endpoint.

### `remove-feature`

```bash
clean-helper remove-feature user_profile
```

Removes the router from `app_router_module.dart`, then deletes `lib/features/<name>/` and `lib/app/navigation/<name>_navigation_impl.dart`. It doesn't run format or build_runner.

### `regenerate-router`

```bash
clean-helper regenerate-router
```

Rebuilds `app_router_module.dart` from every `lib/features/<name>/router/<name>_router.dart` on disk, in alphabetical order. Use it when the file has drifted from the features that exist.

### `build-runner`

```bash
clean-helper build-runner          # build (default)
clean-helper build-runner clean
```

### `generate-localizations`

```bash
clean-helper generate-localizations
```

Runs `dart run slang` in the current project directory. Since 1.3.0 slang's config lives in `packages/<app>_localization/`, so run slang there instead, or use `bootstrap`, which does.

### `generate-tools`

```bash
clean-helper generate-tools [--overwrite | -o]
```

Generates `tools/`: `clean.dart`, `bootstrap.dart [--clean]`, `write_key_properties.dart`, `build_android.dart [aab|apk|both] [--no-clean]`, a shared `command_runner.dart`, and a git-ignored `tools/config/android_build_config.json` for signing. The environment variables `JKS_PATH`, `STORE_PASSWORD`, `KEY_PASSWORD` and `KEY_ALIAS` override the JSON.

### `add-vscode-config`

```bash
clean-helper add-vscode-config
```

Writes `.vscode/extensions.json`, `launch.json` and `tasks.json`, skipping any that exist. `init` runs it automatically.

### `list-mono-repo-apps`

```bash
clean-helper list-mono-repo-apps
```

Prints the declared monorepo apps and how every [configuration](#configuration) key resolves — the quickest way to check your pubspec:

```
Detected mono-repo apps (2):
  1. consumer  (apps/consumer)
  2. organizer  (apps/organizer)

Packages (clean-helper.packages):
  utils:    ropein_utils  (package:ropein_utils/ropein_utils.dart)
  network:  ropein_network  (package:ropein_network/ropein_network_module.dart)

Result type (clean-helper.result_type): task_either (default)

Retrofit call adapter (clean-helper.retrofit_call_adapter):
  RetrofitCallAdapter  (package:ropein_network/ropein_network_module.dart)
```

---

## Configuration

Everything lives under a `clean-helper:` key in `pubspec.yaml`. Every key is optional.

```yaml
clean-helper:
  version: 1.4.4
  mono_repo_apps:
    - apps/consumer
    - apps/organizer
  result_type: task_either
  packages:
    utils:
      name: ropein_utils
      import: package:ropein_utils/ropein_utils.dart
    network:
      name: ropein_network
      import: package:ropein_network/ropein_network_module.dart
  retrofit_call_adapter:
    name: RetrofitCallAdapter
    import: package:ropein_network/ropein_network_module.dart
```

| Key | Default | Purpose |
|---|---|---|
| `version` | written by `init` | Each command warns if it differs from the running tool |
| `mono_repo_apps` | — | App paths in a monorepo — see [Monorepos](#monorepos) |
| [`result_type`](#result_type) | `task_either` | `task_either` or `future_either` |
| [`packages.utils`](#packagesutils) `.name` / `.import` | `<app>_utils` / `package:<name>/<name>.dart` | Shared utils package |
| [`packages.network`](#packagesnetwork) `.name` / `.import` | not set / `package:<name>/<name>.dart` | External network package |
| [`retrofit_call_adapter`](#retrofit_call_adapter) `.name` / `.import` | `RetrofitCallAdapter` / see below | Call adapter used by REST datasources |

**Which pubspec is read.** `mono_repo_apps`, `packages`, `result_type` and `retrofit_call_adapter` are read from the `pubspec.yaml` in the directory where you run the command — the monorepo root, in a monorepo — before the tool switches into the app. `version` is checked afterwards, so in a monorepo it's each app's own `pubspec.yaml` that counts.

### `result_type`

Controls what `add-repo` generates:

- `task_either` (default) — fpdart `TaskEither<Failure, T>` at every layer.
- `future_either` — `Future<Either<Failure, T>>`, with `FutureOr<Either<…>>` in use cases. Use this for projects initialised before 1.4.2, whose call adapter and `UseCaseBase` still use `Future<Either>`.

Any other value stops the command with an error.

### `packages.utils`

The package that `add-repo` and `add-network-module` import shared code from — `Failure`, `UseCaseBase`, `safeExecuteTask` and so on. When it's set:

- Its import replaces `package:<app>_utils/<app>_utils.dart`.
- Generated use cases don't import `lib/core/domain/use_cases/use_case_base.dart`, so the package must export `UseCaseBase`.

If only `import` is given, `name` is taken from it. If only `name` is given, the import is `package:<name>/<name>.dart`.

### `packages.network`

An external package that provides networking in place of `lib/core/network/`. When it's set:

- `add-repo` generates REST datasources even though the app has no `network_module.dart`.
- Its import is used for the call adapter, unless `retrofit_call_adapter.import` is set.
- The tool can't know whether the package registers a `ParseErrorLogger`, so REST datasources mark their `errorLogger` parameter `@ignoreParam` — resolving an unregistered one would throw at runtime. Remove the annotation once the package registers one.

### `retrofit_call_adapter`

This key sits directly under `clean-helper:`, not under `packages:`. `name` is the class used in `@RestApi(callAdapter: …)`. `import` defaults to, in order:

1. `packages.network.import`;
2. `lib/core/network/utils/retrofit_call_adapter.dart`, as a relative import, when that file exists;
3. nothing extra — the utils import already provides it (projects initialised before 1.4.4).

---

## Monorepos

Run commands from the monorepo root. If the current directory has no `lib/` folder, clean-helper reads `mono_repo_apps` from its `pubspec.yaml` and switches into the chosen app before doing anything else:

```yaml
clean-helper:
  mono_repo_apps:
    - apps/consumer
    - apps/organizer
```

- With one app declared, it's used automatically.
- With several, you're prompted — or pass `--scope=<folder name>` before the command:

  ```bash
  clean-helper --scope=organizer add-feature trip_detail
  ```

  If two apps share a folder name, you're prompted between just those. If none matches, the command lists the available names and stops.
- With no `lib/` and no `mono_repo_apps`, the command stops with setup instructions.

When shared code lives in separately named workspace packages rather than `packages/<app>_utils`, add [`packages`](#packagesutils) — and [`retrofit_call_adapter`](#retrofit_call_adapter) if needed — to the same root pubspec. Run `clean-helper list-mono-repo-apps` to check how everything resolves.

---

## What gets generated

### Project layout after `init --network`

```
lib/
├── main.dart
├── app/
│   ├── bootstrap.dart         DI, locale, BlocObserver, runApp
│   ├── main_app.dart
│   ├── di/                    di_container.dart (GetIt), di_initializer.dart (@InjectableInit), app_module.dart
│   ├── navigation/            <feature>_navigation_impl.dart
│   └── router/                app_go_router.dart, app_go_router_redirect.dart, app_router_module.dart
├── core/
│   ├── di/                    core_module.dart (PackageInfo), di_keys.dart
│   ├── domain/use_cases/      use_case_base.dart
│   ├── data/models/           error_model.dart
│   └── network/               constants/, di/, interceptors/, utils/   (add-network-module)
├── features/home/             see add-feature
└── generated/flutter_gen/     assets and colors
packages/
├── clean_router/
├── <app>_localization/
└── <app>_utils/
assets/colors/colors.xml
build.yaml
```

### Workspace packages

| Package | Contents |
|---|---|
| `clean_router` | `CleanRouterBase` — the interface every feature router implements (`routes`, `refreshStreams`, `redirect`, `priority`) — and `CleanRouterRefresh`, which merges the routers' refresh streams for go_router |
| `<app>_localization` | `slang.yaml`, `assets/locales/en.locale.json`, the `String.tr` extension and the generated translations |
| `<app>_utils` | `Failure`, `ErrorEntity`, `AppLogger`, `AppBlocObserver`, `Debouncer`, `safeCast`, `safeExecute`, `safeExecuteTask`, `listToModelList`, `getCurrentFunctionName`, `JsonDecodeFactory`, and an injectable micro-package that registers `BlocObserver` |

The app's `@InjectableInit` pulls in the utils micro-package through `externalPackageModulesAfter`, so build_runner has to run in `packages/<app>_utils` before the app. `init` does this for you.

### Architecture

```
Feature
├── presentation/   page provider → page; bloc (@injectable, freezed events and states)
├── domain/         entities, repository interfaces, params, use cases — no Flutter
└── data/           models (@freezed), datasources (Retrofit), repository implementations
```

- **Routing:** go_router. Each feature router implements `CleanRouterBase`; `AppRouterModule` collects them, sorts them by `priority` (lower first) and builds `AppGoRouter`.
- **DI:** get_it + injectable. `diContainer` lives in `lib/app/di/di_container.dart`.
- **Errors:** fpdart + `Failure`. Retrofit calls go through `RetrofitCallAdapter` → `safeExecuteTask`, so failures come back as `Left(Failure)` rather than exceptions.
- **Serialization:** freezed + json_serializable.
- **Localization:** slang, in `packages/<app>_localization`.
- **Assets:** flutter_gen, configured in `build.yaml`.

---

## Using the generated code

`TaskEither` is lazy — nothing runs until `.run()` — and it composes with `map`, `flatMap` and `orElse` before running:

```dart
final result = await getOrderUseCase(params).run();   // Either<Failure, OrderEntity>
result.fold(
  (failure) => emit(.error(failure.message)),
  (order) => emit(.loaded(order)),
);
```

`UseCaseBase.call` is declared as `FutureOr<TaskEither<Failure, T>>`, so a use case can do async work before building its `TaskEither`. Generated use cases return `TaskEither` directly. When calling through the `UseCaseBase` type, await it first: `await (await useCase(params)).run()`.

---

## Upgrading existing projects

The newer templates work with older projects, as long as you tell the tool what it can't detect:

| Initialised before | What differs | What to do |
|---|---|---|
| 1.4.1 | The utils DI module registers `ParseErrorLogger` | Nothing — `add-network-module` detects it and doesn't register a second one |
| 1.4.2 | Call adapter and `UseCaseBase` use `Future<Either>` | Set `result_type: future_either` |
| 1.4.4 | `RetrofitCallAdapter` / `RetrofitLogger` live in the utils package | Nothing — `add-network-module` detects them and doesn't generate copies in `lib/core/network/utils/` |

Then update `clean-helper.version` to silence the version warning.

---

## Requirements

- Dart SDK ^3.11.3 and a Flutter SDK
- Run from a Flutter project root (with `pubspec.yaml` and `lib/`), or from a monorepo root that declares `mono_repo_apps`
- [fvm](https://fvm.app) is optional and used automatically when installed

Release notes: [CHANGELOG.md](CHANGELOG.md).
