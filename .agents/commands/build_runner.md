# Command: build-runner

**Entry point:** `lib/src/commands/build_runner.dart` → `runBuildRunnerCommand(args)`
**Runner:** `BuildRunnerCommand`

## Usage

```bash
clean-helper build-runner          # build (default)
clean-helper build-runner build
clean-helper build-runner clean
```

| Action | Helper | Runs |
|---|---|---|
| `build` | `functions/build_runner/run_build_runner_build.dart` → `runBuildRunnerBuild()` | `[fvm] dart run build_runner build` (streamed) |
| `clean` | `functions/build_runner/run_build_runner_clean.dart` → `runBuildRunnerClean()` | `[fvm] dart run build_runner clean` (streamed) |

An unknown action prints an error and exits with code 1. `ensurePubspec()` runs first, so `--scope` works.

Generating commands don't use these helpers. They call `runBuildRunner()` from `functions/init/run_build_runner.dart`, which accepts a `workingDirectory`.
