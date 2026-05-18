# Command: list-mono-repo-apps

**Entry point:** `lib/src/commands/list_mono_repo_apps.dart` → `listMonoRepoApps()`
**Binary:** `dart bin/list_mono_repo_apps.dart`

---

## Usage

```bash
clean-helper list-mono-repo-apps
```

No arguments. Run from the monorepo root (or any directory containing `pubspec.yaml`).

---

## What It Does

Reads `clean-helper.mono_repo_apps` from `pubspec.yaml` and prints each declared app with its index and path.

**Example output (monorepo configured):**
```
Detected mono-repo apps (2):
  1. app1  (apps/app1)
  2. app2  (apps/app2)
```

**Example output (no config):**
```
No mono-repo apps configured.
Add a clean-helper section to pubspec.yaml to declare your apps:

  clean-helper:
    mono_repo_apps:
      - apps/app1
      - apps/app2
```

---

## Notes

- **Does NOT call `ensurePubspec()`** — that would trigger project selection before the list can be shown. The pubspec check is done directly instead. This is an intentional exception to the normal command pattern.
- Read-only — makes no changes to the project.
- Works from both a monorepo root and a single-project root.
