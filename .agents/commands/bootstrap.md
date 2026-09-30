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
4. `runSlang('<app>_localization')` — runs slang inside `packages/<app>_localization`
5. `runBuildRunner()` — in the app only

It doesn't run `dart format`.

## Known issue

Unlike `init`, it doesn't run build_runner in `packages/<app>_utils` first. After a clean checkout, the app build can miss `<App>UtilsPackageModule` until the utils package has been built.
