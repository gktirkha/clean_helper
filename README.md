# clean_helper

A Dart CLI tool that scaffolds Flutter projects following **Clean Architecture**.

Run it from inside a Flutter project root to generate the full directory structure, boilerplate files, routing, DI, BLoC state management, and all required dependencies.

---

## Installation

```bash
dart pub global activate --source git https://github.com/gktirkha/clean_helper
```

### Enable Shell Auto-completion

```bash
clean-helper install-completion-files
```

---

## Commands

| Command | Description |
|---------|-------------|
| `clean-helper init` | Full project scaffold — run once on a new Flutter project |
| `clean-helper add_network_module` | Set up the network layer (Dio, Retrofit, Chucker) |
| `clean-helper add_auth_interceptor` | Scaffold AuthInterceptor with token refresh and wire into NetworkModule |
| `clean-helper add_feature <name> [--di]` | Add a new feature with clean architecture structure |
| `clean-helper add_repo <feature> <name> [--no_rest]` | Generate the full data layer (entity, domain repo, datasources, models, repo impl) |
| `clean-helper add_entity <scope> <name> [folder]` | Add an entity (domain) + freezed model (data) |
| `clean-helper build_runner [clean\|build]` | Run build_runner in the current project (default: build) |
| `clean-helper remove_feature <name>` | Remove a feature and deregister its router |
| `clean-helper regenerate_router` | Scan all features on disk and regenerate `router_module.dart` |
| `clean-helper add_vscode_config` | Generate `.vscode/extensions.json`, `launch.json`, and `tasks.json` |
| `clean-helper generate_localizations` | Generate locales using slang |
| `clean-helper list_mono_repo_apps` | List all apps declared in `pubspec.yaml` under `clean-helper.mono_repo_apps` |

`<scope>` for `add_entity` is either `core` or a feature name (e.g. `home`, `auth`). `add_repo` only supports feature scope.

---

## Usage

### `init` — Bootstrap a Flutter project

Run this **once** from the root of a **new** Flutter project:

```bash
cd my_flutter_app
clean-helper init
```

What it does (in order):

1. Validates `pubspec.yaml` exists
2. Reads `name:` from `pubspec.yaml`
3. Creates the full folder scaffold
4. Generates localization files (`slang.yaml`, `assets/locales/en.locale.json`)
5. Generates asset pipeline files (`build.yaml`, `assets/colors/colors.xml`)
6. Scaffolds `packages/clean_router` local workspace package (`CleanRouterBase` + `CleanRouterRefresh`)
7. Patches root `pubspec.yaml` with `workspace: - packages/clean_router`
8. Generates core Dart files (main, bootstrap, DI, routing, string extension)
9. Generates utils (`Failure`, `getCurrentFunctionName`, `safeCast`, `safeExecute`, `listToModelList`, type definitions)
10. Generates home feature scaffold
11. Installs all runtime and dev dependencies
12. Generates VSCode config (`.vscode/extensions.json`, `launch.json`, `tasks.json`)
13. Patches `pubspec.yaml` flutter assets
14. Runs `dart run slang`
15. Runs `dart run build_runner build --delete-conflicting-outputs`
16. Runs `dart format .`

**Dependencies installed:**

| Type | Packages |
|------|----------|
| Runtime | `flutter_bloc`, `go_router`, `get_it`, `injectable`, `freezed_annotation`, `fpdart`, `slang`, `slang_flutter`, `json_annotation`, `package_info_plus`, `flutter_svg`, `flutter_localizations` (SDK), `pretty_dio_logger` (git), `chucker_flutter` (git) |
| Dev | `build_runner`, `injectable_generator`, `freezed`, `flutter_gen_runner`, `json_serializable` |

---

### `add_feature` — Add a new feature

```bash
clean-helper add_feature auth
clean-helper add_feature user_profile
clean-helper add_feature auth --di    # also generate a DI module
```

Feature name must be **snake_case**. Generates:

```
lib/
├── app/navigations/
│   └── auth_navigation_impl.dart      (@LazySingleton, implements AuthNavigation)
└── features/auth/
    ├── data/
    │   ├── constants/
    │   ├── datasources/
    │   ├── models/
    │   │   ├── requests/
    │   │   └── response/
    │   └── repositories/
    ├── di/                            (only with --di flag)
    │   └── auth_module.dart           (@module abstract class AuthModule)
    ├── domain/
    │   ├── entities/
    │   ├── repositories/
    │   └── use_cases/
    ├── presentation/
    │   ├── bloc/auth/
    │   │   ├── auth_bloc.dart         (@lazySingleton, extends Bloc)
    │   │   ├── auth_event.dart        (part of, @freezed)
    │   │   └── auth_state.dart        (part of, @freezed)
    │   ├── pages/
    │   │   └── auth_page.dart
    │   └── widgets/
    └── router/
        ├── auth_routes.dart           (sealed class AuthRoutes)
        ├── auth_navigation.dart       (abstract class AuthNavigation)
        └── auth_router.dart           (@lazySingleton, implements CleanRouterBase)
```

The new feature router is **automatically registered** in `lib/app/router/router_module.dart`. `dart format` and `build_runner` run automatically at the end.

---

### `add_repo` — Add a full data layer

```bash
clean-helper add_repo home invoice
clean-helper add_repo auth user
clean-helper add_repo home invoice --no_rest   # skip REST datasource and API paths
```

Generates the complete data layer for a repository inside `lib/features/<feature>/`:

```
domain/
  entities/invoice_entity.dart                  (abstract class InvoiceEntity)
  repositories/invoice_repository.dart          (abstract interface, get + post methods)
data/
  constants/home_api_paths.dart                 (sealed class HomeApiPaths)
  datasources/invoice_data_source_base.dart     (abstract interface)
  datasources/rest_invoice_data_source.dart     (@RestApi, @Injectable, Retrofit impl)
  models/requests/invoice_request_model.dart    (@JsonSerializable)
  models/response/invoice_response_model.dart   (@freezed, implements InvoiceEntity)
  repositories/invoice_repository_impl.dart     (@Singleton, implements InvoiceRepository)
```

`--no_rest` skips `rest_invoice_data_source.dart` and `home_api_paths.dart`, even if a network module is present. REST files are also skipped automatically if `lib/core/network/di/network_module.dart` does not exist.

All internal imports use relative paths. `dart format` and `build_runner` run automatically at the end.

---

### `add_entity` — Add an entity + model

```bash
# Feature scope
clean-helper add_entity home invoice

# With subfolder (places model in data/models/requests/)
clean-helper add_entity home invoice requests

# Core scope
clean-helper add_entity core error
```

Generates a domain entity and a freezed model:

```dart
// Domain
abstract class InvoiceEntity {}

// Data (freezed + json_serializable)
@freezed
sealed class InvoiceModel with _$InvoiceModel implements InvoiceEntity {
  const factory InvoiceModel() = _InvoiceModel;
  factory InvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceModelFromJson(json);
}
```

`dart format` and `build_runner` run automatically at the end.

---

### `add_auth_interceptor` — Scaffold the auth interceptor

```bash
clean-helper add_auth_interceptor
```

Run this **after** `add_network_module`. Idempotent — skips anything already present. Does three things:

1. Creates `lib/core/network/interceptors/auth_interceptor.dart` — a `@lazySingleton` Dio interceptor with:
   - `onRequest`: attach Bearer token from storage (TODO to implement)
   - `onError`: on 401, refresh the token and retry the original request
   - Refresh deduplication — concurrent 401s share a single refresh call
2. Patches `lib/core/di/di_keys.dart` — adds `DIKeys.noAuthDio` constant
3. Patches `lib/core/network/di/network_module.dart`:
   - Wires `AuthInterceptor` as the first interceptor in the main `Dio` provider
   - Adds a `noAuthDio` provider (Dio **without** `AuthInterceptor`) used by `AuthInterceptor` internally to prevent infinite refresh loops

`build_runner` runs automatically at the end. Fill in the TODOs in `auth_interceptor.dart` afterwards.

---

### `add_network_module` — Set up the network layer

```bash
clean-helper add_network_module
```

Generates Dio + Retrofit network files, installs network dependencies (including `chucker_flutter`), patches `AppGoRouter`, and runs `build_runner` automatically.

---

### `build_runner` — Run build_runner

```bash
clean-helper build_runner         # build (default)
clean-helper build_runner build   # build
clean-helper build_runner clean   # clean generated files
```

---

### `remove_feature` — Remove a feature

```bash
clean-helper remove_feature auth
```

Deletes the feature directory and deregisters its router from `lib/app/router/router_module.dart`.

---

### `regenerate_router` — Rebuild router_module.dart from scratch

```bash
clean-helper regenerate_router
```

Scans `lib/features/` for any feature that has a `router/<feature>_router.dart` file and regenerates `lib/app/router/router_module.dart` from scratch. Features are sorted alphabetically for deterministic output. `router_module.dart` is fully managed by the tool — do not edit it manually. Useful when the module has drifted out of sync or after manual edits to the features directory.

---

### `add_vscode_config` — Generate VSCode configuration

```bash
clean-helper add_vscode_config
```

Generates three files under `.vscode/`:

| File | Purpose |
|------|---------|
| `extensions.json` | Recommended extensions for the project |
| `launch.json` | Debug launch configurations |
| `tasks.json` | Common project tasks |

All files are written with `writeFile` — skipped if they already exist. Also runs automatically as part of `init`.

---

### `list_mono_repo_apps` — List declared mono-repo apps

```bash
clean-helper list_mono_repo_apps
```

Reads `clean-helper.mono_repo_apps` from `pubspec.yaml` and prints every declared app. Useful for verifying monorepo configuration or debugging project detection.

```
Detected mono-repo apps (2):
  1. app1  (apps/app1)
  2. app2  (apps/app2)
```

If no apps are declared, prints setup instructions instead.

---

### `generate_localizations` — Generate locales

```bash
clean-helper generate_localizations
```

Runs `dart run slang` to regenerate `lib/generated/locales/locales.g.dart` from `assets/locales/en.locale.json`.

---

## Generated Architecture

### Clean Architecture Structure

```
Feature
├── domain/           Pure Dart — no Flutter, no packages
│   ├── entities/     Abstract classes (no JSON, no annotations)
│   ├── repositories/ Abstract interfaces
│   └── use_cases/    Business logic
│
└── data/             Implements domain contracts
    ├── models/       @freezed classes implementing entities
    ├── datasources/  API calls via Retrofit
    └── repositories/ @LazySingleton implementations
```

### Dependency Injection — `get_it` + `injectable`

| Annotation | Meaning |
|------------|---------|
| `@lazySingleton` | Created on first access, shared instance |
| `@LazySingleton(as: X)` | Registered as abstract type X |
| `@Singleton(as: X)` | Eager singleton registered as X |
| `@module` | Provides third-party or platform instances |
| `@preResolve` | Awaited before app starts |

`GetIt` instance lives in `lib/app/di/di_container.dart`. `@InjectableInit` bootstraps everything via `diInitializer(diContainer)` in `bootstrap.dart`.

### Routing — `go_router` + `CleanRouterBase`

Router base classes live in the local `packages/clean_router` workspace package. Each feature provides a `CleanRouterBase` implementation:

```dart
abstract interface class CleanRouterBase {
  List<RouteBase> get routes;
  List<Stream<dynamic>> get refreshStreams;
  FutureOr<String?> redirect(BuildContext context, GoRouterState state);
  int get priority; // lower = higher priority
}
```

`RouterModule` collects all `CleanRouterBase` implementations, sorts by `priority`, and builds `AppGoRouter`. `router_module.dart` is tool-owned and regenerated automatically by `add_feature`, `remove_feature`, and `regenerate_router`.

### State Management — `flutter_bloc` + `freezed`

Every feature BLoC:
- Extends `Bloc<FeatureEvent, FeatureState>`
- Is annotated `@lazySingleton` for DI
- Events and states are `@freezed` union types

### Error Handling — `fpdart` + `Failure`

- `Failure` implements `Exception` with an optional `message`
- `Failure.leftFromError(e)` wraps any caught object as `Left<Failure>`
- `safeCast<T>(data, decoder)` — safely casts dynamic API responses to `Either<Failure, T>`
- `safeExecute<T>(exec)` — wraps any async call in `Either<Failure, T>`

### Localization — `slang`

- Config: `slang.yaml` at project root
- Source: `assets/locales/en.locale.json`
- Output: `lib/generated/locales/locales.g.dart`
- `String.tr` extension provides shorthand access to translations

### Asset Generation — `flutter_gen`

- Config: `build.yaml` at project root
- Output: `lib/generated/flutter_gen/`
- Colors sourced from `assets/colors/colors.xml`

---

## Monorepo Support

`clean-helper` works with monorepo Flutter workspaces. Run commands from the **monorepo root** — the tool detects the setup automatically.

### Setup

Add a `clean-helper` section to the root `pubspec.yaml`:

```yaml
clean-helper:
  mono_repo_apps:
    - apps/app1
    - apps/app2
```

### How it works

1. Tool is run from the monorepo root (which has a `pubspec.yaml` but no `lib/` folder).
2. The configured apps are listed and you are prompted to choose one:
   ```
   📦 Multiple mono-repo projects detected. Please select a project:
     1. app1  (apps/app1)
     2. app2  (apps/app2)
   Enter number (1–2):
   ```
3. After selection the command runs as if it were invoked from inside that app's directory — all generated files land in the correct location.

### `--scope` flag

Skip the interactive prompt by passing `--scope=<app_name>` **before** the subcommand:

```bash
clean-helper --scope=app1 init
clean-helper --scope=app1 add_feature login
clean-helper --scope=app2 add_repo home invoice
```

The flag matches on the **folder name** (last segment of the declared path). If two apps share the same name but have different paths, a narrowed prompt is shown for only those matches:

```
⚠️  Multiple apps named "app1" found. Please select one:
  1. app1  (apps/app1)
  2. app1  (packages/app1)
Enter number (1–2):
```

If no app matches, the command aborts and lists all available app names.

### No config, no `lib/`?

If the tool is run from a directory with no `lib/` and no `clean-helper.mono_repo_apps` declaration, it exits with instructions to add the configuration.

---

## Requirements

- Dart SDK `^3.11.3`
- Must be run from the root of a Flutter project (directory containing `pubspec.yaml`), or from a monorepo root with `clean-helper.mono_repo_apps` declared
