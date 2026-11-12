# Command: add-melos-config

**Entry point:** `lib/src/commands/add_melos_config.dart` → `addMelosConfig()`
**Runner:** `AddMelosConfigCommand`

## Usage

```bash
clean-helper add-melos-config
```

Run from the workspace root. It's idempotent: each step skips work that's already done.

## Behaviour

- **Doesn't call `ensurePubspec()`**: melos config belongs in the root pubspec, and `ensurePubspec()` would switch into a monorepo app first. It checks for `pubspec.yaml` itself and aborts without one.
- `installMelos()` → `flutter pub add --dev melos`, skipped when `./pubspec.yaml` already has an indented `melos:` dependency line (`^  melos:`).
- `addMelosToPubspec()` → appends `melosConfigTemplate(toolVersion)` to `./pubspec.yaml` with `overwriteFile`, skipped when a top-level `melos:` key exists.

It doesn't run `dart format` or build_runner.

## Template

`melos_config(version)` is built from raw strings (`r'''`) so the shell syntax in `generate_license` (`$(melos list …)`, `$OSS_IGNORE`) is emitted unchanged; only `version` is spliced in. It defines:

- `command.bootstrap.hooks` — `pre`: `melos use_fvm` and `dart pub global activate clean_helper <toolVersion>` (pub.dev, pinned to the running tool), then slang, flutter_gen, dependency_validator; `post`: `mkdir -p temp`, `melos localize`, `melos autogen`, `melos generate_license`.
- `command.clean.hooks.post` — `git clean -fdX`, `melos use_fvm`.
- `scripts` — `autogen`, `autogen_watch`, `dependency_validator`, `fluttergen`, `generate_license`, `localize`, `update_packages`, `use_fvm`.
