# Command: generate-tools

**Entry point:** `lib/src/commands/generate_tools.dart` → `generateTools({overwrite})`
**Runner:** `GenerateToolsCommand` — flag `--overwrite` / `-o`. Also called by `init --tools` (through `generateToolsFiles()`).

## Usage

```bash
clean-helper generate-tools
clean-helper generate-tools --overwrite
```

Without `--overwrite`, existing files are skipped. With it, the writer is `overwriteFile`: `final write = overwrite ? overwriteFile : writeFile`.

## Output

```
tools/
├── command_runner.dart              shared Process.start helper + fvm detection
├── clean.dart                       [fvm use] → build_runner clean → flutter clean → git clean -fdX (if .git) → remove empty folders
├── bootstrap.dart [--clean]         [clean] → [fvm use] → pub get → dart run slang → build_runner build
├── write_key_properties.dart        android/key.properties from config JSON; env JKS_PATH, STORE_PASSWORD, KEY_PASSWORD, KEY_ALIAS override it
├── build_android.dart [aab|apk|both] [--no-clean]   clean → write_key_properties → flutter build appbundle/apk --release
└── config/android_build_config.json git-ignored signing config
```

Templates: `tools_command_runner`, `tools_clean`, `tools_bootstrap`, `tools_write_key_properties`, `tools_build_android`, `tools_build_config`.

## Known issue

`tools/bootstrap.dart` runs `dart run slang` in the app root, which has the same problem as `generate-localizations`.
