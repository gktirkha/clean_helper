# Command: add-agent-context

**Entry point:** `lib/src/commands/add_agent_context.dart` → `addAgentContext()`
**Runner:** `AddAgentContextCommand`
**Also:** `init --agent-context` (`-a`, off by default) → `runInit(withAgentContext: true)`

## Usage

```bash
clean-helper add-agent-context [--overwrite|-o]
clean-helper init -a
```

## Behaviour

- **Doesn't call `ensurePubspec()`**: the context describes the whole project, so it belongs in the current directory (the workspace root in a monorepo), and `ensurePubspec()` would switch into an app first. It checks for `pubspec.yaml` itself, then calls `loadPackageConfigs()`.
- `generateAgentContext()` (`functions/agent_context/`) writes, relative to the current directory:
  - `.agents/README.md`, `.agents/rules.md`, `.agents/architecture.md` and `.agents/commands/<command>.md` (one per entry in `agentCommandDocs`). Written only when missing (`writeFile`) unless `--overwrite`; `README.md` is always rewritten.
  - `AGENTS.md` and `CLAUDE.md` via `writeAgentPointer()`: created from `agentsMdTemplate()` if missing; if present and not mentioning `.agents/`, `agentsMdPointerLine` is appended; otherwise left alone.
- `--overwrite` → `generateAgentContext(overwrite: true)`: `rules.md`, `architecture.md` and the command docs use `overwriteFile` instead of `writeFile` (write-if-missing). Nothing is ever deleted; project rule files and `AGENTS.md` / `CLAUDE.md` content are never replaced. `README.md` always uses `overwriteFile`, because it indexes the project rule files.
- `resolveAgentContextInfo()` builds the `AgentContextInfo` record the templates take: project name, `readMonoRepoApps()`, `resolvePackagesDir()`, package names, `resolveCallAdapterName()` and `networkAuthInterceptorConfig`. In a monorepo, packages without a configured `name` show as `<app>_<kind>`, since each app has its own default.
- `init --agent-context` runs it last. In a monorepo app (`monoRepoAppPath` set) it changes `Directory.current` to the workspace root (`..` per path segment), generates, and changes back.

## Content

The generated docs are for AI agents in the **generated** project, not in this repo: they are short and rule-first, and don't restate what the code or a command's output already shows. `rules.md` carries the rules (scaffold with clean-helper, independent features, clean layers, data sub-folders, shared modules, package layering, blocs, freezed, never-edit files); `architecture.md` only says where code goes; each command doc is a line on when to run it. Most rules are checked by the `test/architecture_test.dart` that `init` generates (`architectureTestTemplate`): change a rule in both. Commands only useful when setting a project up for humans (`init`, `add-config`, `add-melos-config`, `add-vscode-extensions`, `generate-tools`, `add-agent-context`) are not in `agentCommandDocs`.

When a command's behaviour, the generated layout or the rules change, update `agent_command_docs.dart` and the `agent_context_*` templates in the same change.
