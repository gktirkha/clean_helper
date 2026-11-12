# Command: add-config

**Entry point:** `lib/src/commands/add_config.dart` → `addConfig()`
**Runner:** `AddConfigCommand`

## Usage

```bash
clean-helper add-config
```

## Behaviour

- **Doesn't call `ensurePubspec()`**: the config belongs in the current directory's pubspec (the monorepo root in a monorepo), and `ensurePubspec()` would switch into an app first. It checks for `pubspec.yaml` itself and aborts without one.
- `addConfigToPubspec()` (`functions/config/`) skips when `pubspec.yaml` has a top-level `clean-helper:` key; otherwise it appends `cleanHelperConfigTemplate(version: toolVersion, apps: findMonoRepoApps())` with `overwriteFile`.
- `findMonoRepoApps()` lists `apps/<name>` for each folder under `apps/` with a `pubspec.yaml`, sorted.

## Template (`clean_helper_config`)

Every key from the README's Configuration section, each with a comment line above it — never inline, and every comment indented inside the block (a column-0 comment would end the block for `readMonoRepoApps`).

- Active lines hold the defaults (`create: true`, the slang settings, `auth_interceptor: true`, `use_root_analysis: false`), so the block doesn't change behaviour.
- App-dependent keys (`name`, `import`, `module_name`, `call_adapter_name`) are commented out. `create` is read independently of `name`/`import` (`packageCreateConfig`), so uncommenting just `create: false` works.
- `mono_repo_apps` is filled from `findMonoRepoApps()`, or commented out when empty.

Keep the template in sync with the README sample when keys change.
