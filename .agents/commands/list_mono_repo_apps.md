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
  2. `packages.utils` and `packages.network`: name and import, or their defaults.
  3. `result_type`, or `task_either (default)`.
  4. The resolved call adapter name and import: `retrofit_call_adapter.import` ?? `packages.network.import` ?? `lib/core/network/utils/retrofit_call_adapter.dart`.

Any new `clean-helper:` config key should be printed here too.
