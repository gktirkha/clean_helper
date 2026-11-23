import 'dart:io';

/// A project-owned `*.md` file in `.agents/`: one clean-helper does not
/// write, so it is never overwritten and is listed in the generated README.
class ProjectAgentRule {
  const ProjectAgentRule({required this.fileName, required this.title});

  /// File name relative to `.agents/` (e.g. `shared-layer.md`).
  final String fileName;

  /// The file's first `# ` heading, or the file name if it has none.
  final String title;
}

/// Files in `.agents/` that `add-agent-context` writes itself.
const toolOwnedAgentFiles = {'README.md', 'rules.md', 'architecture.md'};

/// Lists the project-owned `*.md` files directly in [dir] (not
/// `commands/`, which is tool-owned), sorted by name.
List<ProjectAgentRule> findProjectAgentRules([String dir = '.agents']) {
  final directory = Directory(dir);
  if (!directory.existsSync()) return const [];
  final rules = <ProjectAgentRule>[];
  for (final entity in directory.listSync()) {
    if (entity is! File) continue;
    final name = entity.uri.pathSegments.last;
    if (!name.endsWith('.md') || toolOwnedAgentFiles.contains(name)) continue;
    rules.add(ProjectAgentRule(fileName: name, title: _title(entity, name)));
  }
  rules.sort((a, b) => a.fileName.compareTo(b.fileName));
  return rules;
}

String _title(File file, String fallback) {
  for (final line in file.readAsLinesSync()) {
    if (line.startsWith('# ')) return line.substring(2).trim();
  }
  return fallback;
}
