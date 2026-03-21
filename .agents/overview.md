# Project Overview

## What Is clean_helpers?

`clean_helpers` is a **Dart CLI tool** that scaffolds Flutter projects following **Clean Architecture**.
Run it from inside a Flutter project root to generate the full directory structure, boilerplate files,
routing, DI, BLoC state management, and all required dependencies in one command.

---

## CLI Commands

| Binary | Function called | Purpose |
|--------|----------------|---------|
| `dart run bin/init.dart` | `runInit()` | Full project scaffold — run once on a new Flutter project |
| `dart run bin/add_feature.dart <name>` | `addFeature(args)` | Add a new feature with clean architecture structure |
| `dart run bin/add_repo.dart <scope> <name>` | `addRepo(args)` | Add a repository (domain interface + data impl) |
| `dart run bin/add_entity.dart <scope> <name> [folder]` | `addEntity(args)` | Add an entity (domain) + freezed model (data) |

`<scope>` is either `core` or a feature name (e.g. `home`, `auth`).

---

## Public API

`lib/clean_helpers.dart` exports **only the four command files**.
Function files are internal — never export them from the library.

```dart
export 'src/commands/add_entity.dart';
export 'src/commands/add_feature.dart';
export 'src/commands/add_repo.dart';
export 'src/commands/init.dart';
```
