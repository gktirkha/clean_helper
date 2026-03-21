# Project Overview

## What Is clean_helper?

`clean_helper` is a **Dart CLI tool** that scaffolds Flutter projects following **Clean Architecture**.
Run it from inside a Flutter project root to generate the full directory structure, boilerplate files,
routing, DI, BLoC state management, and all required dependencies in one command.

---

## CLI Commands

| Command | Purpose |
|---------|---------|
| `clean-helper init` | Full project scaffold — run once on a new Flutter project |
| `clean-helper add_network_module` | Set up the network layer (Dio, Retrofit, Chucker) |
| `clean-helper add_auth_interceptor` | Scaffold AuthInterceptor with token refresh and wire into NetworkModule |
| `clean-helper add_feature <name>` | Add a new feature with clean architecture structure |
| `clean-helper add_repo <feature> <name>` | Generate the full data layer for a repository (entity, domain repo, datasources, models, repo impl) |
| `clean-helper add_entity <scope> <name> [folder]` | Add an entity (domain) + freezed model (data) |
| `clean-helper build_runner [clean\|build\|watch]` | Run build_runner in the current project (default: build) |
| `clean-helper remove_feature <name>` | Remove a feature and deregister its router |
| `clean-helper regenerate_router` | Scan all features on disk and regenerate `router_module.dart` |
| `clean-helper generate_localizations` | Generate locales using slang |

`<scope>` for `add_entity` is either `core` or a feature name (e.g. `home`, `auth`).
`add_repo` only supports feature scope — not `core`.

Shell completion is provided by [`cli_completion`](https://pub.dev/packages/cli_completion).
Activate it once with: `clean-helper install-completion-files`

---

## Public API

`lib/clean_helper.dart` exports **only the command files**.
Function files are internal — never export them from the library.

```dart
export 'src/commands/add_entity.dart';
export 'src/commands/add_feature.dart';
export 'src/commands/add_network_module.dart';
export 'src/commands/add_repo.dart';
export 'src/commands/build_runner.dart';
export 'src/commands/init.dart';
export 'src/commands/remove_feature.dart';
export 'src/commands/regenerate_router.dart';
export 'src/commands/generate_localizations.dart';
```
