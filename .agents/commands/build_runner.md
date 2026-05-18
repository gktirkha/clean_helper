# Command: build-runner

**Entry point:** `lib/src/commands/build_runner.dart` → `runBuildRunnerCommand(List<String> args)`
**Binary:** `dart run bin/build_runner.dart [clean|build]`

---

## Usage

```bash
clean-helper build-runner           # defaults to build
clean-helper build-runner build     # build
clean-helper build-runner clean     # clean generated files
```

---

## What Each Action Does

| Action | Helper | Underlying command |
|--------|--------|--------------------|
| `build` (default) | `runBuildRunnerBuild()` | `dart run build_runner build` |
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

- `build-runner` is also run automatically at the end of `init`, `add-feature`, `add-repo`, `add-entity`, `add-auth-interceptor`, and `add-network-module` — this command is for manual invocation.
- Use `clean` if generated files are out of sync or causing build errors, then re-run `build`.
