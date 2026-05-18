# Command: generate-tools

**Entry point:** `lib/src/commands/generate_tools.dart` → `generateTools({bool overwrite})`
**Binary:** `dart bin/generate_tools.dart [--overwrite]`

---

## Usage

```bash
clean-helper generate-tools             # skip existing files
clean-helper generate-tools --overwrite # overwrite all files
clean-helper generate-tools -o          # shorthand
```

Must be run from a Flutter project root. Idempotent by default — existing files are skipped.

---

## What It Generates

```
tools/
├── command_runner.dart            # shared Process.start helper + fvmExists()
├── clean.dart                     # cleans build artifacts, git-ignored files, empty folders
├── bootstrap.dart                 # clean (optional) → pub get → slang → build_runner
├── write_key_properties.dart      # writes android/key.properties from config/env vars
├── build_android.dart             # runs write_key_properties then builds AAB/APK
└── config/
    └── android_build_config.json  # keystore config (gitignored)
```

---

## Tool Scripts

### `dart tools/clean.dart`
- Detects fvm; if present runs `fvm use --skip-pub-get` first
- Runs `[fvm] dart run build_runner clean`
- Runs `[fvm] flutter clean`
- Runs `git clean -fdX` only if `.git` exists
- Deletes all empty non-hidden folders recursively

### `dart tools/bootstrap.dart [--clean]`
- `--clean` flag: runs `clean()` first
- Detects fvm; if present runs `fvm use --skip-pub-get`
- Runs `[fvm] flutter pub get`
- Runs `[fvm] dart run slang`
- Runs `[fvm] dart run build_runner build`

### `dart tools/write_key_properties.dart`
- Reads config from `tools/config/android_build_config.json`, env vars override JSON values
- Env vars: `JKS_PATH`, `STORE_PASSWORD`, `KEY_PASSWORD`, `KEY_ALIAS`
- Expands `~/` paths to full home directory path
- Writes `android/key.properties` from resolved config

### `dart tools/build_android.dart [aab|apk|both] [--no-clean]`
- Always runs `clean()` first unless `--no-clean` is passed
- Default mode: `aab`
- Calls `write_key_properties.dart` to set up signing config
- Runs `[fvm] flutter build appbundle --release` and/or `[fvm] flutter build apk --release`

### `tools/config/android_build_config.json`
- Gitignored — never committed
- Fill in `jksPath`, `storePassword`, `keyPassword`, `keyAlias` for local builds
- CI should use environment variables instead

---

## Flags

| Flag | Short | Description |
|------|-------|-------------|
| `--overwrite` | `-o` | Overwrite existing tool files |
