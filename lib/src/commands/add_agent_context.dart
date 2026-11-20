import 'dart:io';

import '../functions/agent_context/generate_agent_context.dart';
import '../functions/shared/abort.dart';
import '../functions/shared/load_package_configs.dart';

// Does NOT call ensurePubspec() — the context describes the whole project, so
// it belongs in the current directory (the workspace root in a monorepo), and
// ensurePubspec() would switch into an app first.

/// Writes `.agents/` (rules, architecture and one file per clean-helper
/// command) plus `AGENTS.md` / `CLAUDE.md` pointers, for AI coding tools.
void addAgentContext() {
  if (!File('pubspec.yaml').existsSync()) {
    abort('pubspec.yaml not found. Run this tool from the project root.');
  }
  loadPackageConfigs();

  stdout.writeln('🚀 Generating AI context...');
  generateAgentContext();
  stdout.writeln();
  stdout.writeln(
    '✅ Done. Rerun after changing the clean-helper: config to refresh it.',
  );
}
