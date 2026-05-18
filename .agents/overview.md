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
| `clean-helper add-network-module` | Set up the network layer (Dio, Retrofit, Chucker) |
| `clean-helper add-auth-interceptor` | Scaffold AuthInterceptor with token refresh and wire into NetworkModule |
| `clean-helper add-feature <name>` | Add a new feature with clean architecture structure |
| `clean-helper add-repo <feature> <name>` | Generate the full data layer for a repository |
| `clean-helper add-entity <scope> <name> [folder]` | Add an entity (domain) + freezed model (data) |
| `clean-helper build-runner [clean\|build]` | Run build_runner in the current project (default: build) |
| `clean-helper bootstrap` | pub get → slang → build_runner (re-bootstrap after git pull) |
| `clean-helper remove-feature <name>` | Remove a feature and deregister its router |
| `clean-helper regenerate-router` | Scan all features on disk and regenerate `app_router_module.dart` |
| `clean-helper generate-localizations` | Generate locales using slang |
| `clean-helper generate-tools [--overwrite]` | Generate `tools/` scripts in the current project |
| `clean-helper add-vscode-config` | Generate `.vscode/` extensions, launch, and tasks config |
| `clean-helper list-mono-repo-apps` | List all apps declared under `clean-helper.mono_repo_apps` in pubspec.yaml |

`<scope>` for `add-entity` is either `core` or a feature name (e.g. `home`, `auth`).
`add-repo` only supports feature scope — not `core`.

Shell completion is provided by [`cli_completion`](https://pub.dev/packages/cli_completion).
Activate it once with: `clean-helper install-completion-files`

---

## Monorepo Support

All commands support monorepo Flutter workspaces transparently.

**Detection (handled automatically by `ensurePubspec()`):**
1. `lib/` folder present → standard single-project mode (no change in behavior).
2. `lib/` absent + root `pubspec.yaml` declares `clean-helper.mono_repo_apps` → user is prompted to select an app; `Directory.current` is updated before the command runs.
3. `lib/` absent + no declaration → command aborts with instructions.

**Configuration** (in the monorepo root `pubspec.yaml`):
```yaml
clean-helper:
  mono_repo_apps:
    - apps/app1
    - apps/app2
```

Run any command from the monorepo root — the tool handles the rest.

**`--scope` flag (global, all commands):**
```bash
clean-helper --scope=app1 add-feature login
```
Skips the interactive prompt by filtering to apps whose folder name matches `app1`.
If two apps share the same name (different paths), a narrowed prompt is shown for just those matches.
If no app matches, the command aborts and lists available names.

---

## Public API

`lib/clean_helper.dart` exports **only the command files**.
Function and template files are internal — never export them from the library.

```dart
export 'src/commands/add_auth_interceptor.dart';
export 'src/commands/add_entity.dart';
export 'src/commands/add_feature.dart';
export 'src/commands/add_network_module.dart';
export 'src/commands/add_repo.dart';
export 'src/commands/add_vscode_config.dart';
export 'src/commands/bootstrap.dart';
export 'src/commands/build_runner.dart';
export 'src/commands/generate_localizations.dart';
export 'src/commands/generate_tools.dart';
export 'src/commands/init.dart';
export 'src/commands/regenerate_router.dart';
export 'src/commands/remove_feature.dart';
```
