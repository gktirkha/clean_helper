# Command: list-mono-repo-apps

**Entry point:** `lib/src/commands/list_mono_repo_apps.dart` → `listMonoRepoApps()`
**Runner:** `ListMonoRepoAppsCommand`

## Usage

```bash
clean-helper list-mono-repo-apps
```

Read-only. Run it from the directory other commands are run from — the monorepo root, in a monorepo.

## Behaviour

- **Doesn't call `ensurePubspec()`**, because that would trigger app selection. It checks for `pubspec.yaml` itself (and aborts without one) and calls `loadPackageConfigs()` directly.
- Prints, in order:
  1. The `mono_repo_apps` entries (`n. <folder>  (<path>)`), or setup instructions if there are none.
  2. `packages.utils` (plus `module_name`, `call_adapter_name`), `packages.localization` (plus every resolved slang setting, marked `(default)` when not configured), `packages.router`, `packages.network` (plus `module_name`, `auth_interceptor`), `overwrite_analysis_options` and `use_root_analysis`: name, import and `— not created` for `create: false`, or their defaults.

Any new `clean-helper:` config key should be printed here too.
