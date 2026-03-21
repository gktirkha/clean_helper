# Project Overview

## What Is clean_helpers?

`clean_helpers` is a **Dart CLI tool** that scaffolds Flutter projects following **Clean Architecture**.
Run it from inside a Flutter project root to generate the full directory structure, boilerplate files,
routing, DI, BLoC state management, and all required dependencies in one command.

---

## CLI Commands

| Command | Purpose |
|---------|---------|
| `clean-helpers init` | Full project scaffold — run once on a new Flutter project |
| `clean-helpers add_network_module` | Set up the network layer (Dio, Retrofit, Chucker) |
| `clean-helpers add_feature <name>` | Add a new feature with clean architecture structure |
| `clean-helpers add_repo <scope> <name>` | Add a repository (domain interface + data impl) |
| `clean-helpers add_entity <scope> <name> [folder]` | Add an entity (domain) + freezed model (data) |

`<scope>` is either `core` or a feature name (e.g. `home`, `auth`).

Shell completion is provided by [`cli_completion`](https://pub.dev/packages/cli_completion).
Activate it once with: `clean-helpers install-completion-files`

---

## Public API

`lib/clean_helpers.dart` exports **only the command files**.
Function files are internal — never export them from the library.

```dart
export 'src/commands/add_entity.dart';
export 'src/commands/add_feature.dart';
export 'src/commands/add_network_module.dart';
export 'src/commands/add_repo.dart';
export 'src/commands/init.dart';
```
