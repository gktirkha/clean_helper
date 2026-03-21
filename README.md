# clean_helpers

A CLI tool for scaffolding Flutter projects following **Clean Architecture** — BLoC, GetIt, GoRouter, Freezed, Dio, and slang, all wired up in one command.

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
- `lib/core/` — DI, routing, network, error handling
- `lib/features/home/` — example home feature
- `assets/` — locales and colors
- Config files: `slang.yaml`, `build.yaml`, `analysis_options.yaml`
- Installs all dependencies and runs `build_runner` + `dart format`

---

### `add-feature <name>`

Adds a new feature with the full clean architecture structure.

```bash
clean-helpers add-feature auth
clean-helpers add-feature user_profile
```

Generates under `lib/features/<name>/`:
- `data/` — models, datasources, repositories
- `domain/` — entities, repository interfaces, use cases
- `presentation/` — BLoC, pages, widgets
- `router/` — routes, navigation, router

> After generating, register the new router in `lib/app/router/router_module.dart`.

---

### `add-repo <scope> <name>`

Adds a repository interface (domain) and its implementation (data).

```bash
clean-helpers add-repo home invoice
clean-helpers add-repo core user
```

`<scope>` is either `core` or an existing feature name.

---

### `add-entity <scope> <name> [folder]`

Adds a domain entity and a corresponding `@freezed` data model.

```bash
clean-helpers add-entity home invoice
clean-helpers add-entity home invoice requests   # nested in data/models/requests/
clean-helpers add-entity core error
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

# 3. Add a feature
clean-helpers add-feature auth

# 4. Add a repository to that feature
clean-helpers add-repo auth token

# 5. Add an entity
clean-helpers add-entity auth token response
```
