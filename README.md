# clean_helpers

A CLI tool for scaffolding Flutter projects following **Clean Architecture** — BLoC, GetIt, GoRouter, Freezed, and slang, all wired up in one command.

---

## Installation

Activate globally from git:

```bash
dart pub global activate --source git https://github.com/gktirkha/clean_helpers
```

Then enable shell auto-completion (bash / zsh / fish):

```bash
clean-helpers install-completion-files
```

Restart your shell or source your profile, and tab completion will work for all commands and arguments.

### As a dev dependency

If you prefer not to install globally, add it as a dev dependency in your Flutter project:

```yaml
# pubspec.yaml
dev_dependencies:
  clean_helpers:
    git:
      url: https://github.com/gktirkha/clean_helpers
```

Then run commands via `dart run`:

```bash
dart run clean_helpers:clean_helpers init
dart run clean_helpers:clean_helpers add_feature auth
```

---

## Commands

### `init`

Scaffolds a full clean architecture structure inside an existing Flutter project.
Run once from the project root (where `pubspec.yaml` lives).

```bash
cd my_flutter_app
clean-helpers init
```

Generates:
- `lib/core/` — DI, routing, error handling
- `lib/features/home/` — example home feature
- `assets/` — locales and colors
- Config files: `slang.yaml`, `build.yaml`, `analysis_options.yaml`
- Installs all dependencies and runs `build_runner` + `dart format`

---

### `add_network_module`

Sets up the network layer: Dio, Retrofit, Chucker, and related dependencies.
Run after `init` if your project needs network/API support.

```bash
clean-helpers add_network_module
```

Generates under `lib/core/network/`:
- `constants/api_paths.dart`
- `interceptors/error_interceptor.dart`
- `di/network_module.dart`

Also generates `lib/core/data/models/error_model.dart` and `lib/core/domain/entities/error_entity.dart`.

---

### `add_feature <name>`

Adds a new feature with the full clean architecture structure.

```bash
clean-helpers add_feature auth
clean-helpers add_feature user_profile
```

Generates under `lib/features/<name>/`:
- `data/` — models, datasources, repositories
- `domain/` — entities, repository interfaces, use cases
- `presentation/` — BLoC, pages, widgets
- `router/` — routes, navigation, router

> After generating, register the new router in `lib/app/router/router_module.dart`.

---

### `add_repo <scope> <name>`

Adds a repository interface (domain) and its implementation (data).

```bash
clean-helpers add_repo home invoice
clean-helpers add_repo core user
```

`<scope>` is either `core` or an existing feature name.

---

### `add_entity <scope> <name> [folder]`

Adds a domain entity and a corresponding `@freezed` data model.

```bash
clean-helpers add_entity home invoice
clean-helpers add_entity home invoice requests   # nested in data/models/requests/
clean-helpers add_entity core error
```

Run `build_runner` after generating to produce `.freezed.dart` and `.g.dart` files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Typical Workflow

```bash
# 1. Create a Flutter project
flutter create my_app && cd my_app

# 2. Scaffold clean architecture
clean-helpers init

# 3. Set up networking
clean-helpers add_network_module

# 4. Add a feature
clean-helpers add_feature auth

# 5. Add a repository to that feature
clean-helpers add_repo auth token

# 6. Add an entity
clean-helpers add_entity auth token response
```
