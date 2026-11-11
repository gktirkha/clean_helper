# Command: bootstrap

**Entry point:** `lib/src/commands/bootstrap.dart` → `runBootstrapCommand()` (async)
**Runner:** `BootstrapCommand`

## Usage

```bash
clean-helper bootstrap
```

## Flow

1. `ensurePubspec()`
2. `fvmUse()` — interactive `fvm use`, a no-op without fvm
3. `runFlutterPubGet()`
4. `runSlang(<localization>)` — runs slang inside `packages/<localization>` (`resolveLocalizationPackage()`); skipped with a note when that folder doesn't exist, i.e. the package lives elsewhere in the workspace
5. `runBuildRunner(workingDirectory: packages/<utils>)` if that folder exists — the app's DI config needs the utils micro-package module — then `runBuildRunner()` in the app

It doesn't run `dart format`.
