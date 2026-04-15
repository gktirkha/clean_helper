# Command: bootstrap

**Entry point:** `lib/src/commands/bootstrap.dart` → `runBootstrapCommand()` [async]

---

## Usage

```bash
clean-helper bootstrap
```

No arguments. Must be run from a Flutter project root.

---

## What It Does (in order)

1. `fvmUse()` — if fvm is installed, runs `fvm use` interactively so the user can select a Flutter version
2. `runFlutterPubGet()` — `[fvm] flutter pub get`
3. `runSlang()` — `[fvm] dart run slang`
4. `runBuildRunner()` — `[fvm] dart run build_runner build --delete-conflicting-outputs`

`[fvm]` means the command is prefixed with `fvm` automatically if fvm is detected.

---

## When To Use

- After `git pull` when dependencies or generated files may have changed
- As a quick full-refresh alternative to running pub get, slang, and build_runner manually

---

## Notes

- `runBootstrapCommand()` is `async` because of `fvmUse()`
- Does **not** run `dart format` — use `build_runner` command or `dart format .` manually if needed
