# Command: add_network_module

**Entry point:** `lib/src/commands/add_network_module.dart` → `addNetworkModule()`
**Binary:** `dart run bin/add_network_module.dart`

---

## Usage

```bash
clean-helper add_network_module
```

No arguments. Must be run from the Flutter project root. Idempotent — `writeFile` skips files that already exist.

---

## What It Does (in order)

1. `generateNetworkFiles()` — writes core network files (see below)
2. `installNetworkDependencies()` — installs runtime and dev packages via `dart pub add`
3. `addChuckerDependency()` — installs `chucker_flutter` from git
4. `patchAppGoRouter()` — adds `ChuckerFlutter.navigatorObserver` to `lib/app/router/app_go_router.dart`
5. `runDartFormat()` — formats the project
6. `runBuildRunner()` — runs `build_runner build --delete-conflicting-outputs`

---

## Generated Files

| File | Template |
|------|----------|
| `lib/core/network/constants/api_paths.dart` | `core_api_paths_template.dart` |
| `lib/core/data/models/error_model.dart` | `error_model_template.dart` |
| `lib/core/network/interceptors/error_interceptor.dart` | `error_interceptor_template.dart` |
| `lib/core/network/di/network_module.dart` | `network_module_template.dart` |

All written with `writeFile` — skipped if they already exist.

---

## Patched Files

**`lib/app/router/app_go_router.dart`** (via `overwriteFile`):
- Adds `import 'package:chucker_flutter/chucker_flutter.dart';` after the flutter import
- Adds `observers: [ChuckerFlutter.navigatorObserver]` before `refreshListenable`
- Skipped silently if the file does not exist

---

## Dependencies Installed

| Type | Packages |
|------|----------|
| Runtime | `dio`, `retrofit`, `json_annotation` |
| Dev | `retrofit_generator`, `json_serializable` |
| Git (runtime) | `pretty_dio_logger` (from `https://github.com/gktirkha/pretty_dio_logger.git`) |
| Git (runtime) | `chucker_flutter` (added by `addChuckerDependency`) |

---

## Notes

- `addNetworkModule()` is also called from `runInit()` when the `--network` flag is passed — the `runBuildRunnerAfter` parameter lets `init` skip the redundant `build_runner` call (it runs its own at the end).
- After running this command, use `add_auth_interceptor` to wire token-based auth into the network layer.
