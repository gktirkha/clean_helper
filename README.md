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
clean-helper init --network                        # full scaffold + network package
clean-helper add-feature orders                    # routing, bloc and page for a feature
clean-helper add-repo orders order --add-sample    # data layer with sample GET/POST
```

`dart format` and `build_runner` run automatically after each generating command.

If [fvm](https://fvm.app) is installed, every `dart`/`flutter` call goes through it, and `init` / `bootstrap` start with `fvm use`. In a monorepo app they skip it, as do the generated `tools/` scripts, because the Flutter version is pinned at the workspace root.

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
| [`remove-feature <name>`](#remove-feature) | Delete a feature and unregister its router |
| [`regenerate-router`](#regenerate-router) | Rebuild `<app>_router_module.dart` from the features on disk |
| [`build-runner [build\|clean]`](#build-runner) | Run build_runner |
| [`generate-localizations`](#generate-localizations) | Run slang |
| [`generate-tools [--overwrite]`](#generate-tools) | Generate `tools/` scripts |
| [`create-packages [--dir=<path>]`](#create-packages) | Create the utils, localization and router packages from config, e.g. at a monorepo root |
| [`add-vscode-extensions`](#add-vscode-extensions) | Add recommended VS Code extensions to `.vscode/extensions.json` |
| [`add-config`](#add-config) | Add a commented `clean-helper:` block with every config key to `pubspec.yaml` |
| [`add-melos-config`](#add-melos-config) | Add melos and its hooks and scripts to the root `pubspec.yaml` |
| [`list-mono-repo-apps`](#list-mono-repo-apps) | Show the resolved monorepo and package config |

### `init`

```bash
clean-helper init [--network] [--di] [--tools]
```

| Flag | Short | Effect |
|---|---|---|
| `--network` | `-n` | Also run `add-network-module` |
| `--di` | `-d` | Also generate a DI module for the `home` feature |
| `--tools` | `-t` | Also generate the `tools/` scripts |

What it does:

1. Writes `analysis_options.yaml` and runs `flutter pub get`.
2. Creates three workspace packages under `packages/`: `clean_router`, `<app>_localization` and `<app>_utils` (see [Workspace packages](#workspace-packages)), and adds them to `workspace:` in `pubspec.yaml`. Their names, imports and whether each is created at all are [configurable](#workspace-packages-create-name-import).
3. Generates the app skeleton: `main.dart`, `bootstrap.dart`, `InitService`, `MainApp`, go_router setup, get_it/injectable DI, and a `home` feature.
4. Installs dependencies, updates `.gitignore`, adds flutter_gen setup (`build.yaml`, `assets/colors/colors.xml`).
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

Runs `fvm use` (if fvm is installed, and not in a monorepo app), `flutter pub get`, slang in the localization package, `build_runner build` in the utils package, then `build_runner build` in the app. The package steps are skipped for packages that aren't under `packages/`. Use it after a `git pull` that changed dependencies or generated inputs.

### `add-feature`

```bash
clean-helper add-feature user_profile [--di]
```

The name must be **snake_case**. It is used as-is for paths, as PascalCase for classes, camelCase for identifiers and kebab-case for the route path — `user_profile` gives `UserProfileRoutes.userProfile = '/user-profile'`.

```
lib/
├── app/navigation/
│   └── user_profile_navigation_impl.dart        @LazySingleton(as: UserProfileNavigation); context optional, falls back to ContextUtils
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
        └── user_profile_router.dart             @lazySingleton, implements <RouterPascal>Base (CleanRouterBase by default)
```

A feature can't have the app's name, because both would generate `<AppPascal>Router`.

The router is registered in `lib/app/router/<app>_router_module.dart` automatically. That file is tool-owned: `add-feature`, `remove-feature` and `regenerate-router` regenerate it, with features in alphabetical order.

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

- The API chain returns fpdart `TaskEither<Failure, T>`; see [Using the generated code](#using-the-generated-code).
- REST files are generated only after [`add-network-module`](#add-network-module) has wired the app (`lib/core/network/di/network_config_module.dart` exists) and `--no-rest` isn't passed. They use the call adapter from the utils package.
- Files that already exist are never overwritten. A second repo in the same feature adds its constant to the existing `<feature>_api_paths.dart`.

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

Sets up networking as a workspace package, configured by [`packages.network`](#packagesnetwork).

1. Unless `create: false` or it already exists, creates the network package in `packages/<app>_network/` and lists it under `workspace:`.
2. Wires the app to it:

| File | Contents |
|---|---|
| `lib/core/network/constants/api_paths.dart` | `ApiPaths.baseUrl` |
| `lib/core/data/models/error_model.dart` | `@freezed` `ErrorModel` implementing `ErrorEntity` — your backend's error body |
| `lib/core/network/interceptors/app_error_interceptor.dart` | `AppErrorInterceptor` — parses error responses into `ErrorModel` |
| `lib/core/network/di/network_config_module.dart` | Registers the package's `NetworkConfig` (base URL, `User-Agent` from `PackageInfo`), `AppErrorInterceptor` as its `ErrorInterceptor` and, with `auth_interceptor`, `AppAuthInterceptor` as its `AuthInterceptor` |
| `lib/core/network/interceptors/app_auth_interceptor.dart` | With `auth_interceptor`: TODOs for reading, refreshing and clearing tokens |
| `lib/app/di/di_initializer.dart` | `.new(<Network>PackageModule)` added to `externalPackageModulesAfter` |
| `lib/app/init_service.dart` | `DioLens.init(...)` after `Bloc.observer` |

3. Installs the package, `dio`, `dio_lens`, `retrofit` and `json_annotation` (plus dev `retrofit_generator` and `json_serializable`), formats, and runs build_runner in the package and then the app.

Existing files are skipped.

### `remove-feature`

```bash
clean-helper remove-feature user_profile
```

Removes the router from `<app>_router_module.dart`, then deletes `lib/features/<name>/` and `lib/app/navigation/<name>_navigation_impl.dart`. It doesn't run format or build_runner.

### `regenerate-router`

```bash
clean-helper regenerate-router
```

Rebuilds `<app>_router_module.dart` from every `lib/features/<name>/router/<name>_router.dart` on disk, in alphabetical order. Use it when the file has drifted from the features that exist.

### `build-runner`

```bash
clean-helper build-runner          # build (default)
clean-helper build-runner clean
```

### `generate-localizations`

```bash
clean-helper generate-localizations
```

Runs slang in the localization package (`packages/<localization>`), where `slang.yaml` lives. Stops with an error if the package isn't under `packages/`.

### `generate-tools`

```bash
clean-helper generate-tools [--overwrite | -o]
```

Generates `tools/`: `clean.dart`, `bootstrap.dart [--clean]` (pub get, then slang and build_runner in the workspace packages and the app), `write_key_properties.dart`, `build_android.dart [aab|apk|both] [--no-clean]`, a shared `command_runner.dart`, and a git-ignored `tools/config/android_build_config.json` for signing. The environment variables `JKS_PATH`, `STORE_PASSWORD`, `KEY_PASSWORD` and `KEY_ALIAS` override the JSON.

### `create-packages`

```bash
clean-helper create-packages                    # into packages/
clean-helper create-packages --dir=shared/libs  # into shared/libs/
```

Creates the utils, localization and router packages described by [`clean-helper.packages`](#workspace-packages-create-name-import), using their names, imports, `module_name` and slang settings, in `<dir>/<name>`. `--dir` defaults to `packages`. `create` is ignored: all three packages are created.

- Run it from the workspace root. It reads and writes the `pubspec.yaml` in the current directory and never prompts for an app. Unconfigured packages get their default names (`<name>_utils`, `<name>_localization`, `clean_router`) from that pubspec's `name`.
- A package whose folder already has a `pubspec.yaml` isn't regenerated. Every package found there still gets its workspace entry, `pub get`, slang and build_runner, so rerunning finishes a run that stopped part-way.
- Created packages are listed under `workspace:` in that `pubspec.yaml`. If it has no `workspace:` key, the key is added. It then runs `flutter pub get`, slang in the localization package and build_runner in the utils package, and formats the code.

Typical monorepo setup: configure `packages` in the root pubspec, run `create-packages` there, and set `create: false` so each app's `init` uses the shared packages instead of creating its own.

Keep each barrel outside `lib/src/` (for example `package:x/x.dart`): importing from another package's `src/` triggers the `implementation_imports` lint.

### `add-vscode-extensions`

```bash
clean-helper add-vscode-extensions
```

Adds clean_helper's recommended extensions to `.vscode/extensions.json` in the current directory: the folder you open in VS Code, which is the monorepo root in a monorepo. The extensions are Dart, Flutter, Bloc, Flutter Helper, Dart Data Class Generator, Flutter Freezed Helper, Pubspec Assist, Remove Comments, XML, YAML, Code Spell Checker and Error Lens.

- It creates the file if it's missing.
- Otherwise it adds only the missing IDs, comparing case-insensitively, and keeps your entries and other keys such as `unwantedRecommendations`.
- A file with comments isn't plain JSON, so it's left alone and the IDs are printed for you to add.

### `add-config`

```bash
clean-helper add-config
```

Appends a `clean-helper:` block to the `pubspec.yaml` in the current directory: the monorepo root in a monorepo. It never prompts for an app. The block lists every [configuration](#configuration) key with a comment above it:

- Explanations use `##` comments. Commented-out options use a single `#`, so you can uncomment one by removing a single `#`.
- Active values are the defaults, so adding the block changes nothing.
- Keys whose default depends on the app, such as package names, imports, `module_name` and `call_adapter_name`, are commented out with the default shown. Uncomment the ones you want to change.
- `version` is the running tool's version.
- `mono_repo_apps` lists the `apps/*/` folders that have a `pubspec.yaml`, and is commented out if there are none.

It's skipped if the pubspec already has a `clean-helper:` key.

### `add-melos-config`

```bash
clean-helper add-melos-config
```

Run from the workspace root (the monorepo root in a monorepo); it writes to the `pubspec.yaml` in the current directory and never prompts for an app. It:

1. Adds `melos` to `dev_dependencies`, unless it's already there.
2. Appends a top-level `melos:` block, unless one already exists:
   - **`bootstrap` hooks** — before: `melos use_fvm`, then globally activates clean_helper, slang, flutter_gen and dependency_validator. After: `melos localize`, `melos autogen`, `melos generate_license`.
   - **`clean` hook** — after: `git clean -fdX`, then `melos use_fvm`.
   - **Scripts** — `autogen`, `autogen_watch` (build_runner in packages that depend on it), `localize` (slang), `fluttergen`, `dependency_validator`, `generate_license` (dart_pubspec_licenses → `lib/generated/oss/oss.dart`), `update_packages`, `use_fvm`.

`generate_license` only runs in packages that depend on `dart_pubspec_licenses`; add it to the app if you want the OSS file.

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
  utils:         my_app_utils  (package:my_app_utils/my_app_utils.dart)
    module_name:       <UtilsPascal>Module (default)
    call_adapter_name: RetrofitCallAdapter (default)
  localization:  <app>_localization (default)
    base_locale: en (default)
    fallback_strategy: base_locale (default)
    input_directory: assets/locales (default)
    input_file_pattern: .locale.json (default)
    output_directory: lib/src/generated (default)
    output_file_name: locales.g.dart (default)
    translate_var: locales (default)
  router:        clean_router (default)
  network:       my_app_network  (package:my_app_network/my_app_network.dart)
    module_name:       <NetworkPascal>Module (default)
    auth_interceptor:  true
  overwrite_analysis_options: true (default)
  use_root_analysis: true (default — monorepo apps include the root file)
```

---

## Configuration

Everything lives under a `clean-helper:` key in `pubspec.yaml`. Every key is optional. The sample below shows every key, with its default noted in the `##` comment above it. Commented-out options use a single `#`. [`add-config`](#add-config) writes the same block with default values. Keep comments indented inside the block.

```yaml
clean-helper:
  ## Stamped by `init`; every command warns when it differs from the running tool.
  version: 1.7.0

  ## Monorepo only: app folders, relative to this pubspec. Commands run from
  ## here switch into one of them (pick with --scope=<folder name>).
  mono_repo_apps:
    - apps/consumer
    - apps/organizer

  ## Monorepo only (read from the root pubspec). Same as packages.use_root_analysis.
  # use_root_analysis: false

  packages:
    ## Shared code: Failure, UseCaseBase, safeExecuteTask, AppLogger, …
    utils:
      ## Package name. Default: <app>_utils.
      name: my_app_utils
      ## Barrel import; init writes the barrel at this path.
      ## Default: package:<name>/<name>.dart.
      import: package:my_app_utils/my_app_utils.dart
      ## false: init doesn't generate it; it already exists in the workspace.
      ## Default: true. create-packages ignores this.
      create: true
      ## The @module class that registers BlocObserver. Default: <UtilsPascal>Module.
      module_name: MyAppUtilsModule
      ## The Retrofit call adapter class in the utils package, used by add-repo
      ## in @RestApi(callAdapter: …). Default: RetrofitCallAdapter.
      call_adapter_name: MyAppCallAdapter

    ## slang translations, used by MainApp, InitService and safeCast.
    localization:
      ## Package name. Default: <app>_localization.
      name: my_app_locales
      ## Barrel import. Default: package:<name>/<name>.dart.
      import: package:my_app_locales/my_app_locales.dart
      ## Same as utils.create.
      create: true
      ## Every key below is written to the package's slang.yaml.
      ## Default locale; the first locale file is <base_locale><input_file_pattern>.
      base_locale: en
      fallback_strategy: base_locale
      ## Where the locale files live, inside the package.
      input_directory: assets/locales
      input_file_pattern: .locale.json
      ## Generated code; must be inside lib/. The barrel exports it.
      output_directory: lib/src/generated
      output_file_name: locales.g.dart
      ## Variable used for translations (locales.general.…), in String.tr and safeCast.
      translate_var: locales

    ## <RouterPascal>Base / <RouterPascal>Refresh (CleanRouterBase by default),
    ## used by <AppPascal>Router and feature routers.
    router:
      ## Package name. Default: clean_router.
      name: my_app_router
      ## Barrel import. Default: package:<name>/<name>.dart.
      import: package:my_app_router/my_app_router.dart
      ## Same as utils.create.
      create: true

    ## Dio, NetworkConfig, interceptors and error model, created by
    ## add-network-module / init --network.
    network:
      ## Package name. Default: <app>_network.
      name: my_app_network
      ## Barrel import. Default: package:<name>/<name>.dart.
      import: package:my_app_network/my_app_network.dart
      ## Same as utils.create.
      create: true
      ## The package's @module class. Default: <NetworkPascal>Module.
      module_name: MyAppNetworkModule
      ## Token handling: abstract AuthInterceptor + noAuthDio in the package,
      ## AppAuthInterceptor in the app. Default: true.
      auth_interceptor: true

    ## true: init and create-packages replace existing analysis_options.yaml
    ## files with the generated ones. false: existing files are kept.
    ## Default: true.
    overwrite_analysis_options: true

    ## Monorepo only. true: apps and packages include the workspace root's
    ## analysis_options.yaml. false: the nearest project's. Default: true.
    use_root_analysis: true
```

| Key | Default | Purpose |
|---|---|---|
| `version` | written by `init` | Each command warns if it differs from the running tool |
| `mono_repo_apps` | — | App paths in a monorepo — see [Monorepos](#monorepos) |
| [`packages.utils`](#packagesutils) `.name` / `.import` / `.create` | `<app>_utils` / `package:<name>/<name>.dart` / `true` | Shared utils package |
| `packages.utils.module_name` | `<UtilsPascal>Module` | The utils package's `@module` class |
| `packages.utils.call_adapter_name` | `RetrofitCallAdapter` | Call adapter class generated and used by REST datasources |
| [`packages.localization`](#packageslocalization) `.name` / `.import` / `.create` | `<app>_localization` / `package:<name>/<name>.dart` / `true` | Localization package; other keys go to `slang.yaml` |
| [`packages.overwrite_analysis_options`](#analysis-options) | `true` | Replace existing `analysis_options.yaml` files with the generated ones |
| [`packages.use_root_analysis`](#analysis-options) | `true` | Monorepo apps and their packages include the workspace root's `analysis_options.yaml` |
| [`packages.router`](#packagesrouter) `.name` / `.import` / `.create` | `clean_router` / `package:<name>/<name>.dart` / `true` | Router package; its classes are `<NamePascal>Base` / `<NamePascal>Refresh` |
| [`packages.network`](#packagesnetwork) `.name` / `.import` / `.create` | `<app>_network` / `package:<name>/<name>.dart` / `true` | Network package |
| `packages.network.module_name` | `<NetworkPascal>Module` | The network package's `@module` class |
| `packages.network.auth_interceptor` | `true` | Auth interceptor and `noAuthDio` |

**Which pubspec is read.** `mono_repo_apps` and `packages` are read from the `pubspec.yaml` in the directory where you run the command — the monorepo root, in a monorepo — before the tool switches into the app. `version` is checked afterwards, so in a monorepo it's each app's own `pubspec.yaml` that counts.

### Workspace packages: `create`, `name`, `import`

`packages.utils`, `packages.localization` and `packages.router` each describe one workspace package. For each:

- If only `import` is given, `name` is taken from it. If only `name` is given, the import is `package:<name>/<name>.dart`. A package that isn't configured uses its default name.
- **`create`** (default `true`) — `init` generates the package in `packages/<name>/`, with its barrel at the path in `import`, and lists it under `workspace:` in the app's `pubspec.yaml`. With `create: false`, `init` assumes the package already exists elsewhere in the workspace, such as at a monorepo root, and only depends on it.
- **No `workspace:` key without created packages.** When nothing is created, `init` leaves the app's `pubspec.yaml` without a `workspace:` key, so the app can be a member of an enclosing workspace. Give the app `resolution: workspace` yourself in that case.
- Every package is added as a dependency without `path:`. Pub resolves workspace members from the workspace.
- `init` runs slang and build_runner only in the packages it creates. Run them yourself, or through [`add-melos-config`](#add-melos-config), for packages that live elsewhere.

### `packages.utils`

The package that `add-repo`, `add-feature` and `add-network-module` import shared code from: `Failure`, `UseCaseBase`, `safeExecuteTask` and so on.

- Its import replaces `package:<app>_utils/<app>_utils.dart`.
- When it's configured, generated use cases import `UseCaseBase` from it, so the package must export `UseCaseBase`.
- `module_name` names the `@module` class in `lib/src/di/<name>_module.dart` that registers `BlocObserver`.
- `call_adapter_name` names the Retrofit call adapter class, generated in the package's `lib/src/network/retrofit_call_adapter.dart` and used by `add-repo` in `@RestApi(callAdapter: …)`. Default: `RetrofitCallAdapter`.

### `packages.localization`

The slang package that `MainApp`, `InitService` and the utils package's `safeCast` import. Every key other than `name`, `import` and `create` is written to the package's `slang.yaml`, overriding these defaults:

```yaml
base_locale: en
fallback_strategy: base_locale
input_directory: assets/locales
input_file_pattern: .locale.json
output_directory: lib/src/generated    # must be inside lib/
output_file_name: locales.g.dart
translate_var: locales
```

The first locale file is `<input_directory>/<base_locale><input_file_pattern>`. The barrel exports the generated file, and `translate_var` is used in `String.tr` and `safeCast`.

### `packages.router`

The package with the router interface and refresh notifier, imported by `<AppPascal>Router` and every feature router. Defaults to `clean_router`. Its files and classes are named after the package: `lib/src/<name>_base.dart` holds `<NamePascal>Base`, and `lib/src/<name>_refresh.dart` holds `<NamePascal>Refresh`. So `food_router` gives `FoodRouterBase` and `FoodRouterRefresh`, and the default gives `CleanRouterBase` and `CleanRouterRefresh`.

### Analysis options

The lint rules are written once. Every other `analysis_options.yaml` only includes that file:

| | `use_root_analysis: false` | `use_root_analysis: true` (default) |
|---|---|---|
| App (`init`) | Full rules | `include: ../../analysis_options.yaml` — the workspace root's, which gets the full rules |
| Packages under the app's `packages/` (`init`, `add-network-module`) | `include: ../../analysis_options.yaml` — the app's | The workspace root's, e.g. `include: ../../../../analysis_options.yaml` |
| Packages under `create-packages`' directory | The current directory's file, which gets the full rules | Same |

`use_root_analysis` only changes anything in a monorepo app, where a root exists above the app. A single project always gets the left-hand column. The key can also sit directly under `clean-helper:`.

`overwrite_analysis_options` (default `true`, also allowed directly under `clean-helper:`) controls whether existing files are replaced:

- `true`: every file in the table is rewritten with the generated content: the app's file, the root file (with `use_root_analysis`), the one `create-packages` writes in its directory, and every workspace package's `include:` file, including packages that already existed.
- `false`: existing files are kept, and only missing ones are created.

A newly created package always gets its `include:` file, because its only existing file is `flutter create`'s default. Packages that already exist follow both settings each time `init`, `create-packages` or `add-network-module` runs.

### `packages.network`

The network package that `add-network-module` (and `init --network`) create and wire the app to. Besides `name` (default `<app>_network`), `import` and `create`:

- `module_name` names the package's `@module` class (default `<NetworkPascal>Module`).
- `auth_interceptor` (default `true`) adds token handling: an abstract `AuthInterceptor` in the package, which attaches the token, refreshes it once on a 401 shared by concurrent failures, and retries the request. It also adds a `@Named(NetworkDIKeys.noAuthDio)` Dio without that interceptor for refresh calls, and an `AppAuthInterceptor` in the app that you fill in. With `false`, `Dio` only has the error and Dio Lens interceptors.

The package is an injectable micro-package. It contains:

| File | Contents |
|---|---|
| `lib/src/models/network_config.dart` | `@freezed` `NetworkConfig` — base URL, timeouts and headers; each app registers one |
| `lib/src/di/<name>_module.dart` | `BaseOptions` from `NetworkConfig`, `Dio` (+ `noAuthDio`), and `RetrofitLogger` registered as `ParseErrorLogger` |
| `lib/src/interceptors/error_interceptor.dart` | Abstract `ErrorInterceptor` — puts the `ErrorEntity` from the app's `parseError` into the response; `shouldHandle` skips 401s and errors without a response |
| `lib/src/interceptors/auth_interceptor.dart` | Abstract `AuthInterceptor` (with `auth_interceptor`) |
| `lib/src/network_di_keys.dart` | `NetworkDIKeys.noAuthDio` (with `auth_interceptor`) |
| `lib/src/utils/retrofit_logger.dart` | `RetrofitLogger` — logs Retrofit parse errors through `AppLogger` |

The call adapter lives in the utils package (`lib/src/network/retrofit_call_adapter.dart`), so REST datasources get it, and `Failure`, from the utils import.

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

When shared code lives in separately named workspace packages, such as root-level packages shared by every app, add [`packages`](#workspace-packages-create-name-import) with `create: false` to the same root pubspec. Run `clean-helper list-mono-repo-apps` to check how everything resolves.

---

## What gets generated

### Project layout after `init --network`

```
lib/
├── main.dart
├── app/
│   ├── bootstrap.dart         binding, InitService().init(), runApp
│   ├── init_service.dart      locale, DI, BlocObserver, DioLens (add-network-module)
│   ├── main_app.dart
│   ├── di/                    di_container.dart (GetIt), di_initializer.dart (@InjectableInit), app_module.dart
│   ├── navigation/            <feature>_navigation_impl.dart
│   └── router/                <app>_router.dart, <app>_router_redirect.dart, <app>_router_module.dart
├── core/
│   ├── di/                    core_module.dart (PackageInfo)
│   ├── data/models/           error_model.dart                          (add-network-module)
│   └── network/               constants/api_paths.dart, di/network_config_module.dart,
│                              interceptors/app_error_interceptor.dart, app_auth_interceptor.dart
├── features/home/             see add-feature
└── generated/flutter_gen/     assets and colors
packages/
├── clean_router/
├── <app>_localization/
├── <app>_network/             add-network-module
└── <app>_utils/
assets/colors/colors.xml
build.yaml
```

### Workspace packages

| Package | Contents |
|---|---|
| `clean_router` | `CleanRouterBase` — the interface every feature router implements (`routes`, `refreshStreams`, `redirect`, `priority`) — and `CleanRouterRefresh`, which merges the routers' refresh streams for go_router. Named after the package: `food_router` → `FoodRouterBase` / `FoodRouterRefresh` |
| `<app>_localization` | `slang.yaml`, `assets/locales/en.locale.json`, the `String.tr` extension and the generated translations |
| `<app>_utils` | `Failure`, `ErrorEntity`, `UseCaseBase`, `AppLogger`, `AppBlocObserver`, `ContextUtils`, `Debouncer`, `safeCast`, `safeExecute`, `safeExecuteTask`, `listToModelList`, `getCurrentFunctionName`, `JsonDecodeFactory`, the Retrofit call adapter, and an injectable micro-package that registers `BlocObserver` |
| `<app>_network` | `NetworkConfig`, `Dio` (+ `noAuthDio`), `RetrofitLogger` and the abstract `ErrorInterceptor` / `AuthInterceptor`, as an injectable micro-package — see [`packages.network`](#packagesnetwork) |

The app's `@InjectableInit` pulls in the utils and network micro-packages through `externalPackageModulesAfter`, so build_runner has to run in those packages before the app. `init`, `bootstrap` and `tools/bootstrap.dart` do this for you.

### Architecture

```
Feature
├── presentation/   page provider → page; bloc (@injectable, freezed events and states)
├── domain/         entities, repository interfaces, params, use cases — no Flutter
└── data/           models (@freezed), datasources (Retrofit), repository implementations
```

- **Routing:** go_router. The app's router is `<AppPascal>Router` in `lib/app/router/<app>_router.dart`. Each feature router implements the router package's `<RouterPascal>Base` (`CleanRouterBase` by default); `<AppPascal>RouterModule` collects them, sorts them by `priority` (lower first) and builds `AppGoRouter`.
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

## Requirements

- Dart SDK ^3.11.3 and a Flutter SDK
- Run from a Flutter project root (with `pubspec.yaml` and `lib/`), or from a monorepo root that declares `mono_repo_apps`
- `add-network-module` installs `dio_lens`, which needs Dart ^3.13.7 (Flutter 3.47.8+) in the target project
- [fvm](https://fvm.app) is optional and used automatically when installed

Release notes: [CHANGELOG.md](CHANGELOG.md).
