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
/// `.agents/` (README, rules, architecture, one file per command) and the
/// `AGENTS.md` / `CLAUDE.md` pointers. Nothing is ever deleted.
///
/// `rules.md`, `architecture.md` and the command docs are written only when
/// missing, unless [overwrite]. `README.md` is the index of every file in
/// `.agents/`, so it is always rewritten. Any other `*.md` file directly in
/// `.agents/` is a project-owned rule file: never touched, and listed in the
/// README after `architecture.md`.
void generateAgentContext({bool overwrite = false}) {
  final write = overwrite ? overwriteFile : writeFile;
  final info = resolveAgentContextInfo();
  final projectRules = findProjectAgentRules();

  overwriteFile(
    '.agents/README.md',
    agentContextReadmeTemplate(info, toolVersion, projectRules: projectRules),
  );
  write('.agents/rules.md', agentContextRulesTemplate(info));
  write('.agents/architecture.md', agentContextArchitectureTemplate(info));
  for (final doc in agentCommandDocs) {
    write('.agents/commands/${doc.name}.md', agentContextCommandTemplate(doc));
  }
  writeAgentPointer('AGENTS.md');
  writeAgentPointer('CLAUDE.md');
  for (final rule in projectRules) {
    stdout.writeln('  📌 Kept (project rule): .agents/${rule.fileName}');
  }
  stdout.writeln('🤖 AI context written to .agents/');
  if (!overwrite) {
    stdout.writeln(
      '   Existing files were kept; use --overwrite to refresh them.',
    );
  }
}
