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

Add it to your Flutter project's `pubspec.yaml`:

```yaml
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
- `lib/core/` — DI container, routing base, router refresh
- `lib/app/` — bootstrap, main app, GoRouter setup
- `lib/features/home/` — example home feature
- `assets/` — locales and colors
- Config files: `slang.yaml`, `build.yaml`, `analysis_options.yaml`
- Installs all core dependencies and runs `build_runner` + `dart format`

---

### `add_network_module`

Sets up the network layer: Dio, Retrofit, Chucker, and related dependencies.
Run after `init` when your project needs API/network support.

```bash
clean-helpers add_network_module
```

Generates under `lib/core/network/`:
- `constants/api_paths.dart`
- `interceptors/error_interceptor.dart`
- `di/network_module.dart`

Also generates:
- `lib/core/data/models/error_model.dart`
- `lib/core/domain/entities/error_entity.dart`

Patches `lib/app/router/app_go_router.dart` to add the Chucker navigator observer.

---

### `add_feature <name>`

Adds a new feature with the full clean architecture structure and auto-registers its router.

```bash
clean-helpers add_feature auth
clean-helpers add_feature user_profile
```

Generates under `lib/features/<name>/`:
- `data/` — models, datasources, repositories
- `domain/` — entities, repository interfaces, use cases
- `presentation/` — BLoC, pages, widgets
- `router/` — routes, navigation, router

Also creates `lib/app/navigations/<name>_navigation_impl.dart` and registers the router in `lib/app/router/router_module.dart` automatically.

---

### `remove_feature <name>`

Removes a feature and deregisters its router. The inverse of `add_feature`.

```bash
clean-helpers remove_feature auth
clean-helpers remove_feature user_profile
```

Deletes `lib/features/<name>/` and `lib/app/navigations/<name>_navigation_impl.dart`, and removes the router registration from `lib/app/router/router_module.dart`.

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

Run `build_runner` after generating to produce `.freezed.dart` and `.g.dart` files.

---

### `build_runner [clean|build|watch]`

Runs `build_runner` inside the current project. Defaults to `build` if no action is specified.

```bash
clean-helpers build_runner          # same as build
clean-helpers build_runner clean
clean-helpers build_runner build
clean-helpers build_runner watch
```

`build` and `watch` always run with `--delete-conflicting-outputs`.

---

## Typical Workflow

```bash
# 1. Create a Flutter project
flutter create my_app && cd my_app

# 2. Scaffold clean architecture
clean-helpers init

# 3. Set up networking (optional)
clean-helpers add_network_module

# 4. Add a feature
clean-helpers add_feature auth

# 5. Add a repository to that feature
clean-helpers add_repo auth token

# 6. Add an entity
clean-helpers add_entity auth token response

# 7. Regenerate code
clean-helpers build_runner build

# 8. Remove a feature you no longer need
clean-helpers remove_feature auth
```
