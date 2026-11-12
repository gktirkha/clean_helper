# Command: add-vscode-extensions

**Entry point:** `lib/src/commands/add_vscode_extensions.dart` → `addVscodeExtensions()`
**Runner:** `AddVscodeExtensionsCommand`

## Usage

```bash
clean-helper add-vscode-extensions
```

## Behaviour

- **Doesn't call `ensurePubspec()`**: `.vscode/` belongs to the folder opened in VS Code (the monorepo root in a monorepo), so it works on the current directory and needs no pubspec.
- `writeVscodeExtensions()` (`functions/vscode/`):
  - no `.vscode/extensions.json` → writes `vscodeExtensionsTemplate(vscodeRecommendedExtensions)` with `overwriteFile`;
  - existing file → `jsonDecode`, appends the IDs from `vscodeRecommendedExtensions` missing from `recommendations` (case-insensitive), keeps every other key, re-encodes with 4-space indent;
  - not plain JSON (JSONC comments) → warns with the IDs and leaves the file alone.
- The list is `vscodeRecommendedExtensions` in `templates/vscode_extensions_template.dart`.

`init` doesn't run it.
