import 'dart:io';

import '../../templates/agent_context_architecture_template.dart';
import '../../templates/agent_context_command_template.dart';
import '../../templates/agent_context_readme_template.dart';
import '../../templates/agent_context_rules_template.dart';
import '../shared/tool_version.dart';
import '../shared/write_file.dart';
import 'agent_command_docs.dart';
import 'project_agent_rules.dart';
import 'resolve_agent_context_info.dart';
import 'write_agent_pointer.dart';

/// Writes the AI context for the project in the current directory:
/// `.agents/` (README, rules, architecture, one file per command; tool-owned,
/// rewritten each run) and the `AGENTS.md` / `CLAUDE.md` pointers.
///
/// Any other `*.md` file directly in `.agents/` is a project-owned rule file:
/// it is never touched, and the README lists it after `architecture.md`.
///
/// With [overwrite], `.agents/` is deleted first (project rule files and stale
/// command docs included) and `AGENTS.md` / `CLAUDE.md` are replaced with the
/// template instead of getting the pointer line appended.
void generateAgentContext({bool overwrite = false}) {
  if (overwrite) _deleteAgentsDir();
  final info = resolveAgentContextInfo();
  final projectRules = findProjectAgentRules();

  overwriteFile(
    '.agents/README.md',
    agentContextReadmeTemplate(info, toolVersion, projectRules: projectRules),
  );
  overwriteFile('.agents/rules.md', agentContextRulesTemplate(info));
  overwriteFile(
    '.agents/architecture.md',
    agentContextArchitectureTemplate(info),
  );
  for (final doc in agentCommandDocs) {
    overwriteFile(
      '.agents/commands/${doc.name}.md',
      agentContextCommandTemplate(doc),
    );
  }
  writeAgentPointer('AGENTS.md', overwrite: overwrite);
  writeAgentPointer('CLAUDE.md', overwrite: overwrite);
  for (final rule in projectRules) {
    stdout.writeln('  📌 Kept (project rule): .agents/${rule.fileName}');
  }
  stdout.writeln('🤖 AI context written to .agents/');
}

/// Deletes `.agents/`, listing the files that won't be regenerated (project
/// rule files, stale command docs).
void _deleteAgentsDir() {
  final dir = Directory('.agents');
  if (!dir.existsSync()) return;
  final generated = {
    '.agents/README.md',
    '.agents/rules.md',
    '.agents/architecture.md',
    for (final doc in agentCommandDocs) '.agents/commands/${doc.name}.md',
  };
  for (final file in dir.listSync(recursive: true).whereType<File>()) {
    final path = file.path.replaceFirst('./', '');
    if (!generated.contains(path)) stdout.writeln('  🗑  Removed: $path');
  }
  dir.deleteSync(recursive: true);
}
