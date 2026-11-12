import 'dart:io';

import '../shared/write_file.dart';
import 'warn_stale_workspace_entries.dart';

/// Lists each of [packagePaths] (e.g. `packages/my_utils`) under
/// `workspace:` in `pubspec.yaml`. A missing key is added before
/// `dependencies:`, or at the end when there's no `dependencies:`. With no
/// packages, the pubspec is left alone: packages that `init` doesn't create
/// already belong to an enclosing workspace.
void addPackagesWorkspace(List<String> packagePaths) {
  if (packagePaths.isEmpty) {
    stdout.writeln(
      '  ⏭  No packages created — workspace: not added to pubspec.yaml',
    );
    return;
  }

  final content = File('pubspec.yaml').readAsStringSync();
  final missing = [
    for (final path in packagePaths)
      if (!RegExp(
        '^\\s+-\\s+${RegExp.escape(path)}/?\\s*\$',
        multiLine: true,
      ).hasMatch(content))
        path,
  ];
  if (missing.isEmpty) {
    stdout.writeln('  ⏭  Skipped (exists): workspace entries');
    return;
  }

  final entries = missing.map((p) => '  - $p\n').join();
  final workspace = RegExp(r'^workspace:[ \t]*\n', multiLine: true);
  final dependencies = RegExp(r'^dependencies:', multiLine: true);
  final updated = workspace.hasMatch(content)
      ? content.replaceFirstMapped(workspace, (m) => '${m[0]}$entries')
      : dependencies.hasMatch(content)
      ? content.replaceFirst(
          dependencies,
          'workspace:\n$entries\ndependencies:',
        )
      : '${content.trimRight()}\n\nworkspace:\n$entries';

  overwriteFile('pubspec.yaml', updated);
  warnStaleWorkspaceEntries(updated);
  stdout.writeln(
    '📋 Workspace entries added to pubspec.yaml (${missing.join(', ')})',
  );
}
