# clean_helper

A Dart CLI that scaffolds Flutter apps in **Clean Architecture** and keeps generating code in the same shape as the app grows: features, repositories, entities, routing, dependency injection, BLoC and the network layer.

It works in a single Flutter app and in a pub-workspace monorepo with several apps and shared packages.

---

## Contents

- [Installation](#installation)
- [Quick start](#quick-start)
- [How it works](#how-it-works)
- [Commands](#commands)
  - Project setup: [`init`](#init) · [`bootstrap`](#bootstrap) · [`create-packages`](#create-packages) · [`add-network-module`](#add-network-module)
  - Code generation: [`add-feature`](#add-feature) · [`add-repo`](#add-repo) · [`add-entity`](#add-entity) · [`remove-feature`](#remove-feature) · [`regenerate-router`](#regenerate-router)
  - Build steps: [`build-runner`](#build-runner) · [`generate-localizations`](#generate-localizations)
  - Workspace and tooling: [`add-config`](#add-config) · [`add-melos-config`](#add-melos-config) · [`add-vscode-extensions`](#add-vscode-extensions) · [`generate-tools`](#generate-tools)
  - Inspection: [`list-mono-repo-apps`](#list-mono-repo-apps)
- [Configuration](#configuration)
- [Monorepos](#monorepos)
- [The generated project](#the-generated-project)
- [Using the generated code](#using-the-generated-code)
- [Requirements](#requirements)
- [Sample configuration](#sample-configuration)

---

## Installation

From [pub.dev](https://pub.dev/packages/clean_helper):

```bash
dart pub global activate clean_helper
```

From a local checkout:

```bash
dart pub global activate --source path /path/to/clean_helper
```

A path activation runs a compiled snapshot. After changing the source, run the activate command again so `clean-helper` picks it up.

```bash
clean-helper --version                # check the installed version
clean-helper install-completion-files # shell completion, one-off
```

---

## Quick start

### A single app

```bash
flutter create my_app && cd my_app
clean-helper init --network                        # scaffold + network package
clean-helper add-feature orders                    # routes, router, bloc, page
clean-helper add-repo orders order --add-sample    # data + domain layer with sample GET/POST
```

### A monorepo

```bash
cd my_workspace                         # root pubspec.yaml with workspace: and apps under apps/
clean-helper add-config                 # write the clean-helper: block, then edit it
clean-helper create-packages            # shared utils / localization / router (+ network) packages
clean-helper --scope=consumer init --network
```

See [Monorepos](#monorepos) for the full setup.

---

## How it works

- **Run it from the project root.** In a monorepo, run it from the workspace root: commands that work on an app switch into it first (see [Monorepos](#monorepos)).
- **Configuration lives in `pubspec.yaml`**, under a `clean-helper:` key. Every key is optional. See [Configuration](#configuration).
- **Shared code lives in workspace packages:** utils, localization, router and, optionally, network. `init` creates them under `packages/` and lists them under `workspace:`, unless you point it at packages that already exist.
- **Your files are never overwritten.** Generated files that already exist are skipped. The exceptions are files clean_helper owns, such as the app's router module and `analysis_options.yaml` (see [`overwrite_analysis_options`](#analysis-options)).
- **Generating commands finish the job.** They run `dart format` and `build_runner` when they're done, in the packages first and then the app.
- **fvm is used when installed.** Every `dart` and `flutter` call goes through [fvm](https://fvm.app). `init` and `bootstrap` start with `fvm use`, except in a monorepo app, where the Flutter version is pinned at the root.
- **A failing step stops the run.** If an external command (`flutter create`, `pub`, `build_runner`, slang, `dart format`) fails, clean-helper prints its output and exits with code 1.

---

## Commands

Global options go **before** the command:

| Option | Description |
|---|---|
| `--scope=<app>` | In a monorepo, pick the app by folder name instead of being prompted |
| `--version` | Print the clean-helper version and exit |
| `-h`, `--help` | Show help; `clean-helper <command> --help` shows a command's options |

| Command | Description |
|---|---|
| **Project setup** | |
| [`init`](#init) | Scaffold a new Flutter project, once |
| [`bootstrap`](#bootstrap) | `pub get`, slang and build_runner after a checkout or pull |
| [`create-packages`](#create-packages) | Create the configured workspace packages, e.g. at a monorepo root |
| [`add-network-module`](#add-network-module) | Create the network package and wire the app to it |
| **Code generation** | |
| [`add-feature`](#add-feature) | A feature: routes, router, navigation, bloc and page |
| [`add-repo`](#add-repo) | A repository's data and domain layers |
| [`add-entity`](#add-entity) | A domain entity and its freezed model |
| [`remove-feature`](#remove-feature) | Delete a feature and unregister its router |
| [`regenerate-router`](#regenerate-router) | Rebuild the router module from the features on disk |
| **Build steps** | |
| [`build-runner`](#build-runner) | `build_runner build` or `clean` |
| [`generate-localizations`](#generate-localizations) | Run slang in the localization package |
| **Workspace and tooling** | |
| [`add-config`](#add-config) | Add a commented `clean-helper:` block with every config key |
| [`add-melos-config`](#add-melos-config) | Add melos with bootstrap hooks and scripts |
| [`add-vscode-extensions`](#add-vscode-extensions) | Add recommended VS Code extensions |
| [`generate-tools`](#generate-tools) | Generate `tools/` scripts for cleaning, bootstrapping and Android builds |
| **Inspection** | |
| [`list-mono-repo-apps`](#list-mono-repo-apps) | Show the monorepo apps and how every config key resolves |

---

### `init`

Scaffolds Clean Architecture into a project fresh from `flutter create`. Run it once.

```bash
clean-helper init [--network] [--di] [--tools]
```

| Option | Short | Effect |
|---|---|---|
| `--network` | `-n` | Also run [`add-network-module`](#add-network-module) |
| `--di` | `-d` | Also generate a DI module for the `home` feature |
| `--tools` | `-t` | Also run [`generate-tools`](#generate-tools) |

**What it does**

1. Runs `fvm use` (single apps only), writes `analysis_options.yaml` and runs `flutter pub get`.
2. Creates the router, localization and utils packages under `packages/` and lists them under `workspace:`. Packages with [`create: false`](#workspace-packages) are skipped; if none are created, the pubspec gets no `workspace:` key.
3. Generates the app skeleton:
   - `main.dart`, `bootstrap.dart`, `InitService` and `MainApp`
   - the go_router setup in `lib/app/router/`
   - get_it and injectable DI
   - flutter_gen setup: `build.yaml` and `assets/colors/colors.xml`
   - a `home` feature
4. Adds the dependencies below and a clean-helper block to `.gitignore` (generated files, `pubspec.lock`, build output, signing config).
5. With `--network`, creates the network package and wires the app to it. With `--tools`, writes `tools/`.
6. Points every package's `analysis_options.yaml` at the shared rules.
7. Runs slang in the localization package, then build_runner in the utils and network packages and then the app, then `dart format`.
8. Sorts the dependencies in every pubspec and stamps `clean-helper.version`.

**Dependencies added to the app**

- **Runtime:** `flutter_bloc`, `go_router`, `get_it`, `injectable`, `freezed_annotation`, `fpdart`, `package_info_plus`, `flutter_svg`, `json_annotation`, `logger`, `flutter_localizations` (SDK)
- **Dev:** `build_runner`, `injectable_generator`, `freezed`, `flutter_gen_runner`, `json_serializable`
- **Workspace packages:** the router, localization and utils packages, without `path:`. Pub resolves them from the workspace.

---

### `bootstrap`

Gets a checkout ready to run, after a clone or a `git pull` that changed dependencies or generated inputs.

```bash
clean-helper bootstrap
```

It runs these steps in order:

1. `fvm use` (if fvm is installed, and not in a monorepo app)
2. `flutter pub get`
3. slang in the localization package
4. `build_runner build` in the utils and network packages
5. `build_runner build` in the app

Package steps run only for packages under the app's `packages/`. Packages elsewhere in the workspace are left to their owner, for example [melos](#add-melos-config).

---

### `create-packages`

Creates the workspace packages from your configuration. It's typically run once at a monorepo root, so every app can share the packages.

```bash
clean-helper create-packages                    # into packages/
clean-helper create-packages --dir=shared/libs  # into shared/libs/
```

| Option | Default | Effect |
|---|---|---|
| `--dir=<path>` | `packages` | Folder to create the packages in, relative to the current directory |

**What it does**

1. Creates the utils, localization and router packages described by [`clean-helper.packages`](#configuration) in `<dir>/<name>`. It also creates the network package when `packages.network` is configured. `create` is ignored here: every package is created.
2. Writes the full lint rules to `analysis_options.yaml` in the current directory, and points each package's `analysis_options.yaml` at it.
3. Lists the packages under `workspace:` in the current `pubspec.yaml`, adding the key if it's missing. It warns about `workspace:` entries whose folder has no `pubspec.yaml`, since `pub get` fails on them.
4. Runs `flutter pub get`, slang in the localization package, build_runner in the utils and network packages, then sorts the package pubspecs and formats the code.

**Notes**

- It works on the current directory's `pubspec.yaml` and never prompts for an app. Unconfigured packages get default names from that pubspec's `name`: `<name>_utils`, `<name>_localization`, `clean_router`.
- A package whose folder already has a `pubspec.yaml` isn't regenerated. It still gets steps 2–4, so rerunning finishes a run that stopped part-way.
- Afterwards, set `create: false` for these packages so each app's `init` uses them instead of creating its own.
- Keep each barrel import outside `lib/src/`, for example `package:x/x.dart`. Importing another package's `src/` triggers the `implementation_imports` lint.

---

### `add-network-module`

Sets up networking as a workspace package, configured by [`packages.network`](#packagesnetwork). `init --network` runs it for you.

```bash
clean-helper add-network-module
```

**What it does**

1. Creates the network package in `packages/<app>_network/` and lists it under `workspace:`, unless it has `create: false` or already exists.
2. Wires the app to it:

   | File | Contents |
   |---|---|
   | `lib/core/network/constants/api_paths.dart` | `ApiPaths.baseUrl` |
   | `lib/core/data/models/error_model.dart` | `@freezed` `ErrorModel` implementing `ErrorEntity`: your backend's error body |
   | `lib/core/network/interceptors/app_error_interceptor.dart` | `AppErrorInterceptor`, which parses error responses into `ErrorModel` |
   | `lib/core/network/interceptors/app_auth_interceptor.dart` | `AppAuthInterceptor`, with TODOs for reading, refreshing and clearing tokens (only with `auth_interceptor`) |
   | `lib/core/network/di/network_config_module.dart` | Registers the package's `NetworkConfig` (base URL, `User-Agent` from `PackageInfo`), `AppErrorInterceptor` and `AppAuthInterceptor` |
   | `lib/app/di/di_initializer.dart` | `.new(<Network>PackageModule)` added to `externalPackageModulesAfter` |
   | `lib/app/init_service.dart` | `DioLens.init(...)` after `Bloc.observer` |

3. Adds the package, `dio`, `dio_lens`, `retrofit` and `json_annotation`, plus dev `retrofit_generator` and `json_serializable`.
4. Formats, then runs build_runner in the package and then the app.

App files that already exist are skipped. After it runs, [`add-repo`](#add-repo) generates REST datasources.

---

### `add-feature`

Adds a feature with routing, a bloc and a page, and registers its router.

```bash
clean-helper add-feature user_profile [--di]
```

| Option | Short | Effect |
|---|---|---|
| `--di` | `-d` | Also generate `di/<feature>_module.dart`, an injectable `@module` |

The name must be **snake_case**. It's used as-is for paths, in PascalCase for classes, in camelCase for identifiers and in kebab-case for the route path. For example, `user_profile` gives `UserProfileRoutes.userProfile = '/user-profile'`. A feature can't have the app's name, because both would generate `<AppPascal>Router`.

**Generated files**

```
lib/
├── app/navigation/
│   └── user_profile_navigation_impl.dart        @LazySingleton(as: UserProfileNavigation)
└── features/user_profile/
    ├── di/user_profile_module.dart              only with --di
    ├── presentation/
    │   ├── bloc/user_profile/
    │   │   ├── user_profile_bloc.dart           @injectable
    │   │   ├── user_profile_event.dart          part of the bloc, @freezed
    │   │   └── user_profile_state.dart          part of the bloc, @freezed
    │   ├── page_providers/
    │   │   └── user_profile_page_provider.dart  BlocProvider + navigation from DI
    │   └── pages/
    │       └── user_profile_page.dart           pure UI, takes navigation as a parameter
    └── router/
        ├── user_profile_routes.dart             route path constants
        ├── user_profile_navigation.dart         goToUserProfile([BuildContext? context])
        └── user_profile_router.dart             @lazySingleton, implements <RouterPascal>Base
```

**Notes**

- The router is registered in `lib/app/router/<app>_router_module.dart`. That file is tool-owned: `add-feature`, `remove-feature` and `regenerate-router` rewrite it, with features in alphabetical order.
- Navigation takes an optional context. Without one, it falls back to `ContextUtils.currentContext` from the utils package, and logs an error if that's unavailable.
- The bloc is `@injectable`, so each page gets a new instance, because `BlocProvider` closes the bloc when the page is disposed.

---

### `add-repo`

Adds a repository to a feature: entity, repository interface and implementation, datasource and, with a network package, a Retrofit datasource.

```bash
clean-helper add-repo <feature> <repo_name> [--add-sample] [--no-rest]
```

| Option | Effect |
|---|---|
| `--add-sample` | Adds sample `get<Name>` / `post<Name>` methods at every layer, plus request and response models, params and use cases |
| `--no-rest` | Skips the Retrofit datasource and API paths |

**Generated files** for `clean-helper add-repo orders order --add-sample`

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
    ├── constants/orders_api_paths.dart               REST
    ├── datasources/order_data_source_base.dart       abstract interface
    ├── datasources/rest_order_data_source.dart       REST: @RestApi(callAdapter: …), @Injectable
    ├── models/requests/order_request_model.dart      --add-sample
    ├── models/response/order_response_model.dart     --add-sample: @freezed, implements OrderEntity
    └── repositories/order_repository_impl.dart       @Singleton(as: OrderRepository)
```

**Notes**

- Every layer returns fpdart `TaskEither<Failure, T>`. See [Using the generated code](#using-the-generated-code).
- REST files are generated once [`add-network-module`](#add-network-module) has wired the app, meaning `lib/core/network/di/network_config_module.dart` exists. They use the call adapter from the utils package.
- A second repo in the same feature adds its constant to the existing `<feature>_api_paths.dart`. Other existing files are skipped.

---

### `add-entity`

Adds a domain entity and the freezed model that implements it, in a feature or in `lib/core/`.

```bash
clean-helper add-entity <feature|core> <entity_name> [folder]
```

```bash
clean-helper add-entity home invoice            # feature scope
clean-helper add-entity home invoice requests   # model in data/models/requests/
clean-helper add-entity core error              # lib/core/
```

It generates `domain/entities/<name>_entity.dart` (an abstract class) and `data/models/[<folder>/]<name>_model.dart`, a `@freezed` class implementing the entity, with `fromJson`.

---

### `remove-feature`

Deletes a feature.

```bash
clean-helper remove-feature user_profile
```

It removes the feature's router from `<app>_router_module.dart`, deletes `lib/features/<name>/` and `lib/app/navigation/<name>_navigation_impl.dart`, then formats and runs build_runner, so the generated DI config drops the feature.

---

### `regenerate-router`

Rebuilds the router module from the features on disk.

```bash
clean-helper regenerate-router
```

It rewrites `lib/app/router/<app>_router_module.dart` from every `lib/features/<name>/router/<name>_router.dart`, in alphabetical order, then formats. Use it when the module has drifted from the features that exist.

---

### `build-runner`

Runs build_runner in the app.

```bash
clean-helper build-runner          # build (default)
clean-helper build-runner clean
```

Any other action stops with an error.

---

### `generate-localizations`

Runs slang in the localization package (`packages/<localization>/`), where `slang.yaml` lives.

```bash
clean-helper generate-localizations
```

It stops with an error if the package isn't under the app's `packages/`. Run slang where the package lives instead, or use [melos](#add-melos-config).

---

### `add-config`

Adds a `clean-helper:` block listing every [configuration](#configuration) key to the current directory's `pubspec.yaml`, the workspace root in a monorepo.

```bash
clean-helper add-config
```

- Each key has a `##` comment above it explaining what it does and its default.
- Keys with a fixed default are active with that value, so adding the block changes nothing.
- Keys whose default depends on the app, such as names, imports and class names, are commented out with a single `#`. Uncomment one by removing that `#`.
- `version` is the running tool's version.
- `mono_repo_apps` lists every `apps/*/` folder that has a `pubspec.yaml`. If there are none, the key is commented out.

The pubspec is left alone if it already has a `clean-helper:` key. It never prompts for an app.

---

### `add-melos-config`

Adds [melos](https://melos.invertase.dev) to the current directory's `pubspec.yaml`, the workspace root in a monorepo.

```bash
clean-helper add-melos-config
```

1. Adds `melos` to `dev_dependencies`, unless it's already there.
2. Appends a top-level `melos:` block, unless one exists:
   - **`bootstrap` hooks.** Before: `melos use_fvm`, then `dart pub global activate` for clean_helper (from pub.dev, pinned to the running version), slang, flutter_gen and dependency_validator. After: `melos localize`, `melos autogen` and `melos generate_license`.
   - **`clean` hook.** After: `git clean -fdX`, then `melos use_fvm`.
   - **Scripts:**
     - `autogen` and `autogen_watch`: build_runner in every package that depends on it
     - `localize`: slang
     - `fluttergen`
     - `dependency_validator`
     - `generate_license`: dart_pubspec_licenses → `lib/generated/oss/oss.dart`
     - `update_packages`
     - `use_fvm`

`generate_license` only runs in packages that depend on `dart_pubspec_licenses`, so add that package to the app if you want the OSS file. The pinned clean_helper version isn't updated later; edit it in the hook when you upgrade.

---

### `add-vscode-extensions`

Adds clean_helper's recommended extensions to `.vscode/extensions.json` in the current directory. That's the folder you open in VS Code: the workspace root in a monorepo.

```bash
clean-helper add-vscode-extensions
```

The recommended extensions:

- Dart and Flutter
- Bloc, Flutter Helper, Dart Data Class Generator and Flutter Freezed Helper
- Pubspec Assist, Remove Comments, XML and YAML
- Code Spell Checker and Error Lens

- If the file is missing, it's created.
- Otherwise only the missing IDs are added, compared case-insensitively. Your entries and other keys, such as `unwantedRecommendations`, are kept.
- A file with comments isn't plain JSON, so it's left alone and the IDs are printed for you to add.

`init` doesn't run this command.

---

### `generate-tools`

Generates Dart scripts in `tools/` that work with or without fvm.

```bash
clean-helper generate-tools [--overwrite]
```

| Option | Short | Effect |
|---|---|---|
| `--overwrite` | `-o` | Replace existing files instead of skipping them |

| Script | Does |
|---|---|
| `tools/clean.dart` | `fvm use`, build_runner clean, `flutter clean`, `git clean -fdX`, then removes empty folders |
| `tools/bootstrap.dart [--clean]` | Optionally cleans, then `pub get`, slang in the localization package, build_runner in the workspace packages and then the app |
| `tools/write_key_properties.dart` | Writes `android/key.properties` from the signing config |
| `tools/build_android.dart [aab\|apk\|both] [--no-clean]` | Cleans, writes `key.properties` and builds a release appbundle and/or APK |
| `tools/command_runner.dart` | Shared process and fvm helpers |
| `tools/config/android_build_config.json` | Signing config, git-ignored. `JKS_PATH`, `STORE_PASSWORD`, `KEY_PASSWORD` and `KEY_ALIAS` override it |

In a monorepo app, the scripts skip `fvm use`.

---

### `list-mono-repo-apps`

Prints the monorepo apps and how every [configuration](#configuration) key resolves. It's the quickest way to check your pubspec, and it changes nothing.

```bash
clean-helper list-mono-repo-apps
```

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

Everything lives under a `clean-helper:` key in `pubspec.yaml`, and every key is optional. In a monorepo, the keys are read from the root pubspec, except `version`, which each app's pubspec stamps for itself.

[`add-config`](#add-config) writes a commented block with every key for you. A full example is in [Sample configuration](#sample-configuration) at the end of this README.

| Key | Default | Purpose |
|---|---|---|
| `version` | written by `init` | Each command warns if it differs from the running tool |
| `mono_repo_apps` | — | App paths in a monorepo; see [Monorepos](#monorepos) |
| [`packages.utils`](#packagesutils) `.name` / `.import` / `.create` | `<app>_utils` / `package:<name>/<name>.dart` / `true` | Shared utils package |
| `packages.utils.module_name` | `<UtilsPascal>Module` | The utils package's `@module` class |
| `packages.utils.call_adapter_name` | `RetrofitCallAdapter` | The Retrofit call adapter class |
| [`packages.localization`](#packageslocalization) `.name` / `.import` / `.create` | `<app>_localization` / `package:<name>/<name>.dart` / `true` | Localization package; other keys go to `slang.yaml` |
| [`packages.router`](#packagesrouter) `.name` / `.import` / `.create` | `clean_router` / `package:<name>/<name>.dart` / `true` | Router package; classes `<NamePascal>Base` / `<NamePascal>Refresh` |
| [`packages.network`](#packagesnetwork) `.name` / `.import` / `.create` | `<app>_network` / `package:<name>/<name>.dart` / `true` | Network package |
| `packages.network.module_name` | `<NetworkPascal>Module` | The network package's `@module` class |
| `packages.network.auth_interceptor` | `true` | Auth interceptor and `noAuthDio` |
| [`packages.overwrite_analysis_options`](#analysis-options) | `true` | Replace existing `analysis_options.yaml` files |
| [`packages.use_root_analysis`](#analysis-options) | `true` | Monorepo apps and their packages include the root's `analysis_options.yaml` |

### Workspace packages

`packages.utils`, `packages.localization`, `packages.router` and `packages.network` each describe one workspace package:

- **`name` and `import`.** If only `import` is given, `name` is taken from it. If only `name` is given, the import is `package:<name>/<name>.dart`. The barrel file is written at the path in `import`.
- **`create`** (default `true`). With `true`, `init` generates the package in `packages/<name>/` and lists it under `workspace:` in the app's pubspec. With `false`, the package already exists elsewhere in the workspace, for example at a monorepo root, so the app only depends on it. If nothing is created, the app's pubspec gets no `workspace:` key; give the app `resolution: workspace` yourself.
- **Dependencies.** Every package is added as a dependency without `path:`, and pub resolves it from the workspace.
- **Build steps.** `init` runs slang and build_runner only in packages it creates. For packages elsewhere, use [`create-packages`](#create-packages) or [melos](#add-melos-config).

### `packages.utils`

The package that every generated layer imports shared code from: `Failure`, `ErrorEntity`, `UseCaseBase`, `safeExecuteTask`, `AppLogger`, `ContextUtils` and the Retrofit call adapter.

- `module_name` names the `@module` class in `lib/src/di/<name>_module.dart` that registers `BlocObserver`.
- `call_adapter_name` names the call adapter in `lib/src/network/retrofit_call_adapter.dart`, which [`add-repo`](#add-repo) uses in `@RestApi(callAdapter: …)`.

### `packages.localization`

The slang package that `MainApp`, `InitService` and the utils package's `safeCast` import. Every key other than `name`, `import` and `create` goes to the package's `slang.yaml`, overriding these defaults:

```yaml
base_locale: en
fallback_strategy: base_locale
input_directory: assets/locales
input_file_pattern: .locale.json
output_directory: lib/src/generated    # must be inside lib/
output_file_name: locales.g.dart
translate_var: locales
```

The first locale file is `<input_directory>/<base_locale><input_file_pattern>`. The barrel exports the generated file, and `translate_var` is the variable `String.tr` and `safeCast` use.

### `packages.router`

The package with the router interface and refresh notifier, used by `<AppPascal>Router` and every feature router. Its files and classes are named after the package:

| File | Class |
|---|---|
| `lib/src/<name>_base.dart` | `<NamePascal>Base`: `routes`, `refreshStreams`, `redirect`, `priority` |
| `lib/src/<name>_refresh.dart` | `<NamePascal>Refresh`: merges the routers' refresh streams for go_router |

The default `clean_router` gives `CleanRouterBase` and `CleanRouterRefresh`, and `food_router` gives `FoodRouterBase` and `FoodRouterRefresh`.

### `packages.network`

The network package that [`add-network-module`](#add-network-module) creates. It's an injectable micro-package:

| File | Contents |
|---|---|
| `lib/src/models/network_config.dart` | `@freezed` `NetworkConfig`: base URL, timeouts and headers; each app registers one |
| `lib/src/di/<name>_module.dart` | `BaseOptions` from `NetworkConfig`, `Dio` (+ `noAuthDio`), and `RetrofitLogger` registered as `ParseErrorLogger` |
| `lib/src/interceptors/error_interceptor.dart` | Abstract `ErrorInterceptor`: puts the `ErrorEntity` returned by the app's `parseError` into the response; `shouldHandle` skips 401s and errors without a response |
| `lib/src/interceptors/auth_interceptor.dart` | Abstract `AuthInterceptor` (with `auth_interceptor`) |
| `lib/src/network_di_keys.dart` | `NetworkDIKeys.noAuthDio` (with `auth_interceptor`) |
| `lib/src/utils/retrofit_logger.dart` | `RetrofitLogger`, which logs Retrofit parse errors through `AppLogger` |

- **`module_name`** names the `@module` class.
- **`auth_interceptor: true`** (the default) adds token handling: the abstract `AuthInterceptor` attaches the token, refreshes it once on a 401 (concurrent failures share one refresh) and retries the request. It also adds a `@Named(NetworkDIKeys.noAuthDio)` Dio without that interceptor, used for the refresh call. The app implements `AppAuthInterceptor`.
- **`auth_interceptor: false`** gives `Dio` only the error and Dio Lens interceptors.

### Analysis options

The lint rules are written once, and every other `analysis_options.yaml` only includes that file:

| | `use_root_analysis: false` | `use_root_analysis: true` (default) |
|---|---|---|
| App (`init`) | Full rules | `include:` the workspace root's file, which gets the full rules |
| Packages under the app's `packages/` | `include:` the app's file | `include:` the workspace root's file |
| Packages under `create-packages`' directory | `include:` that directory's file, which gets the full rules | Same |

- **`use_root_analysis`** only matters in a monorepo app, where there's a root above the app. A single project always gets the left-hand column.
- **`overwrite_analysis_options: true`** (the default) means these files are rewritten every time `init`, `create-packages` or `add-network-module` runs, including the include files of packages that already exist. With **`false`**, existing files are kept and only missing ones are written.
- Both keys can also sit directly under `clean-helper:`.

---

## Monorepos

clean-helper works with a pub workspace that has several apps and shared packages.

### Choosing an app

Run commands from the workspace root. If the current directory has no `lib/`, clean-helper reads `mono_repo_apps` from its `pubspec.yaml` and switches into the chosen app:

- With one app declared, it's used automatically.
- With several, you're prompted. Or pass `--scope=<folder name>` before the command:

  ```bash
  clean-helper --scope=consumer add-feature trip_detail
  ```

  If two apps share a folder name, you're prompted between just those. If none matches, the available names are listed.
- With no `lib/` and no `mono_repo_apps`, the command stops with setup instructions.

[`add-config`](#add-config), [`add-melos-config`](#add-melos-config), [`add-vscode-extensions`](#add-vscode-extensions), [`create-packages`](#create-packages) and [`list-mono-repo-apps`](#list-mono-repo-apps) always work on the current directory and never switch into an app.

### Setting up shared packages

1. In the root pubspec, run `clean-helper add-config`, then set the package names, and set `create: false` for the packages the apps will share.
2. Run `clean-helper create-packages` at the root. It creates the packages in `packages/`, lists them under `workspace:` and builds them.
3. For each app, add `resolution: workspace` to its pubspec and list it under the root's `workspace:`.
4. Run `clean-helper --scope=<app> init --network` for each app. The app depends on the shared packages, and with `use_root_analysis` it includes the root's lint rules.
5. Optionally, run `clean-helper add-melos-config` and `clean-helper add-vscode-extensions` at the root.

Run `clean-helper list-mono-repo-apps` at any point to check how the configuration resolves.

---

## The generated project

### Layout after `init --network`

```
lib/
├── main.dart
├── app/
│   ├── bootstrap.dart         binding, InitService().init(), runApp
│   ├── init_service.dart      locale, DI, BlocObserver, DioLens
│   ├── main_app.dart          MaterialApp.router + TranslationProvider
│   ├── di/                    di_container.dart (GetIt), di_initializer.dart (@InjectableInit), app_module.dart
│   ├── navigation/            <feature>_navigation_impl.dart
│   └── router/                <app>_router.dart, <app>_router_redirect.dart, <app>_router_module.dart
├── core/
│   ├── di/                    core_module.dart (PackageInfo)
│   ├── data/models/           error_model.dart
│   └── network/               constants/api_paths.dart, di/network_config_module.dart,
│                              interceptors/app_error_interceptor.dart, app_auth_interceptor.dart
├── features/home/             see add-feature
└── generated/flutter_gen/     assets and colors
packages/
├── clean_router/
├── <app>_localization/
├── <app>_network/
└── <app>_utils/
assets/colors/colors.xml
build.yaml
```

### Workspace packages

| Package | Contents |
|---|---|
| Router (`clean_router`) | `<NamePascal>Base`, the interface every feature router implements, and `<NamePascal>Refresh` |
| Localization (`<app>_localization`) | `slang.yaml`, the first locale file, the `String.tr` extension and the generated translations |
| Utils (`<app>_utils`) | `Failure`, `ErrorEntity`, `UseCaseBase`, `AppLogger`, `AppBlocObserver`, `ContextUtils`, `Debouncer`, `safeCast`, `safeExecute`, `safeExecuteTask`, `listToModelList`, `getCurrentFunctionName`, `JsonDecodeFactory`, the Retrofit call adapter, and an injectable micro-package that registers `BlocObserver` |
| Network (`<app>_network`) | `NetworkConfig`, `Dio` (+ `noAuthDio`), `RetrofitLogger` and the abstract `ErrorInterceptor` / `AuthInterceptor`, as an injectable micro-package |

The app's `@InjectableInit` pulls in the utils and network micro-packages through `externalPackageModulesAfter`, so build_runner must run in those packages before the app. `init`, `bootstrap`, `create-packages` and `tools/bootstrap.dart` do this in that order.

### Architecture

```
Feature
├── presentation/   page provider → page; bloc (@injectable, freezed events and states)
├── domain/         entities, repository interfaces, params, use cases — no Flutter
└── data/           models (@freezed), datasources (Retrofit), repository implementations
```

- **Routing:** go_router. `<AppPascal>Router` in `lib/app/router/<app>_router.dart` builds the `GoRouter`. Each feature router implements the router package's `<RouterPascal>Base`, and `<AppPascal>RouterModule` collects them, sorted by `priority` (lower first).
- **DI:** get_it and injectable. `diContainer` lives in `lib/app/di/di_container.dart`, and the packages register themselves as micro-packages.
- **Errors:** fpdart and `Failure`. Retrofit calls go through the call adapter to `safeExecuteTask`, so failures come back as `Left(Failure)` rather than exceptions.
- **Serialization:** freezed and json_serializable.
- **Localization:** slang, in the localization package.
- **Assets:** flutter_gen, configured in `build.yaml`.

---

## Using the generated code

`TaskEither` is lazy: nothing runs until `.run()`. You can compose it with `map`, `flatMap` and `orElse` before running:

```dart
final result = await getOrderUseCase(params).run();   // Either<Failure, OrderEntity>
result.fold(
  (failure) => emit(.error(failure.message)),
  (order) => emit(.loaded(order)),
);
```

`UseCaseBase.call` is declared as `FutureOr<TaskEither<Failure, T>>`, so a use case can do async work before building its `TaskEither`. Generated use cases return `TaskEither` directly. When you call through the `UseCaseBase` type, await it first: `await (await useCase(params)).run()`.

---

## Requirements

- Dart SDK `^3.13.4` to run clean-helper, plus a Flutter SDK.
- The network package uses `dio_lens`, which needs Dart `^3.13.7` (Flutter 3.47.8+) in the target project.
- Run commands from a Flutter project root (with `pubspec.yaml` and `lib/`), or from a workspace root that declares `mono_repo_apps`.
- [fvm](https://fvm.app) is optional and used automatically when installed.

Release notes: [CHANGELOG.md](CHANGELOG.md).

---

## Sample configuration

Every key, with what it does and its default in the `##` comment above it. Commented-out options use a single `#`. Keep comments indented inside the block. [`add-config`](#add-config) writes the same block with default values.

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
