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
| `clean-helper add_feature <name>` | Add a new feature with clean architecture structure |
| `clean-helper add_repo <scope> <name>` | Add a repository (domain interface + data impl) |
| `clean-helper add_entity <scope> <name> [folder]` | Add an entity (domain) + freezed model (data) |
| `clean-helper build_runner [clean\|build\|watch]` | Run build_runner in the current project (default: build) |
| `clean-helper remove_feature <name>` | Remove a feature and deregister its router |
| `clean-helper regenerate_router` | Scan all features on disk and regenerate `router_module.dart` |

`<scope>` is either `core` or a feature name (e.g. `home`, `auth`).

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
6. Generates core Dart files (main, bootstrap, DI, routing)
7. Generates network layer (Dio, error interceptor, network module)
8. Generates home feature scaffold
9. Installs all runtime and dev dependencies
10. Patches `pubspec.yaml` flutter assets
11. Runs `dart run slang`
12. Runs `dart run build_runner build --delete-conflicting-outputs`
13. Runs `dart format .`

**Dependencies installed:**

| Type | Packages |
|------|----------|
| Runtime | `flutter_bloc`, `go_router`, `get_it`, `injectable`, `freezed_annotation`, `fpdart`, `slang`, `slang_flutter`, `dio`, `retrofit`, `json_annotation`, `package_info_plus`, `flutter_svg`, `pretty_dio_logger` (git), `chucker_flutter` (git), `flutter_localizations` |
| Dev | `build_runner`, `injectable_generator`, `freezed`, `retrofit_generator`, `json_serializable`, `flutter_gen_runner` |

---

### `add_feature` — Add a new feature

```bash
clean-helper add_feature auth
clean-helper add_feature user_profile
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
        └── auth_router.dart           (@lazySingleton, implements RouterBase)
```

The new feature router is **automatically registered** in `lib/app/router/router_module.dart`.

---

### `add_repo` — Add a repository

```bash
# Inside a feature
clean-helper add_repo home invoice

# In core
clean-helper add_repo core user
```

Generates a domain abstract interface and a data implementation:

```dart
// Domain
abstract interface class InvoiceRepository {}

// Data
@LazySingleton(as: InvoiceRepository)
class InvoiceRepositoryImpl implements InvoiceRepository {}
```

---

### `add_entity` — Add an entity + model

```bash
# Basic
clean-helper add_entity home invoice

# With subfolder (places model in data/models/requests/)
clean-helper add_entity home invoice requests

# In core
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

After generating, run build_runner:

```bash
clean-helper build_runner build
```

---

### `add_network_module` — Set up the network layer

```bash
clean-helper add_network_module
```

Generates Dio + Retrofit network files, installs network dependencies (including `chucker_flutter`), and patches `AppGoRouter`.

---

### `build_runner` — Run build_runner

```bash
clean-helper build_runner         # build (default)
clean-helper build_runner build   # build
clean-helper build_runner watch   # watch mode
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

Scans `lib/features/` for any feature that has a `router/<feature>_router.dart` file and regenerates `lib/app/router/router_module.dart` from scratch. `router_module.dart` is fully managed by the tool — do not edit it manually. Useful when the module has drifted out of sync or after manual edits to the features directory.

---

## Generated Architecture

### Clean Architecture Structure

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

### Dependency Injection — `get_it` + `injectable`

| Annotation | Meaning |
|------------|---------|
| `@lazySingleton` | Created on first access, shared instance |
| `@LazySingleton(as: X)` | Registered as abstract type X |
| `@Singleton(as: X)` | Eager singleton registered as X |
| `@module` | Provides third-party or platform instances |
| `@preResolve` | Awaited before app starts |

### Routing — `go_router` + `RouterBase`

Each feature provides a `RouterBase` implementation:

```dart
abstract interface class RouterBase {
  List<RouteBase> get routes;
  List<Stream<dynamic>> get refreshStreams;
  FutureOr<String?> redirect(BuildContext context, GoRouterState state);
  int get priority; // lower = higher priority
}
```

### State Management — `flutter_bloc` + `freezed`

Every feature BLoC:
- Extends `Bloc<FeatureEvent, FeatureState>`
- Is annotated `@lazySingleton` for DI
- Events and states are `@freezed` union types

### Localization — `slang`

- Config: `slang.yaml` at project root
- Source: `assets/locales/en.locale.json`
- Output: `lib/core/generated/locales/locales.g.dart`

### Asset Generation — `flutter_gen`

- Config: `build.yaml` at project root
- Output: `lib/core/generated/flutter_gen/`
- Colors sourced from `assets/colors/colors.xml`

---

## Requirements

- Dart SDK `^3.11.3`
- Must be run from the root of a Flutter project (directory containing `pubspec.yaml`)
