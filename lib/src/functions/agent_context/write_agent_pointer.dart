import 'dart:io';

import '../../templates/agents_md_template.dart';
import '../shared/write_file.dart';

/// Points [path] (`AGENTS.md` / `CLAUDE.md`) at `.agents/`: creates it, or
/// appends the pointer line when the file exists but doesn't mention
/// `.agents/` yet. Existing content is never replaced.
void writeAgentPointer(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    overwriteFile(path, agentsMdTemplate());
    return;
  }
  final content = file.readAsStringSync();
  if (content.contains('.agents/') || content.contains('.agents folder')) {
    stdout.writeln('  ⏭  $path already points at .agents/');
    return;
  }
  overwriteFile(path, '${content.trimRight()}\n\n$agentsMdPointerLine\n');
}
