# Command: build_runner

**Entry point:** `lib/src/commands/build_runner.dart` → `runBuildRunnerCommand(List<String> args)`
**Binary:** `dart run bin/build_runner.dart [clean|build]`

---

## Usage

```bash
clean-helper build_runner           # defaults to build
clean-helper build_runner build     # build (--delete-conflicting-outputs)
clean-helper build_runner clean     # clean generated files
```

---

## What Each Action Does

| Action | Helper | Underlying command |
|--------|--------|--------------------|
| `build` (default) | `runBuildRunnerBuild()` | `dart run build_runner build --delete-conflicting-outputs` |
| `clean` | `runBuildRunnerClean()` | `dart run build_runner clean` |

An unknown action prints an error and exits with code 1.

---

## Implementation Notes

- Each action lives in its own helper file under `lib/src/functions/build_runner/`:
  - `run_build_runner_build.dart` → `runBuildRunnerBuild()`
  - `run_build_runner_clean.dart` → `runBuildRunnerClean()`
- Output is streamed in real time via `runCommandStreamed`.
- `ensurePubspec()` is called first — aborts if `pubspec.yaml` is not found.

---

## Notes

- `build_runner` is also run automatically at the end of `init`, `add_feature`, `add_repo`, `add_entity`, `add_auth_interceptor`, and `add_network_module` — this command is for manual invocation.
- Use `clean` if generated files are out of sync or causing build errors, then re-run `build`.
