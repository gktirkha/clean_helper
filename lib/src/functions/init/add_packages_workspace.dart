import 'dart:io';

import '../shared/write_file.dart';

/// Lists `packages/<name>` for each of [packageNames] under `workspace:` in
/// `pubspec.yaml`, adding the key before `dependencies:` if it's missing.
/// With no packages, the pubspec is left alone: packages that `init` doesn't
/// create already belong to an enclosing workspace.
void addPackagesWorkspace(List<String> packageNames) {
  if (packageNames.isEmpty) {
    stdout.writeln(
      '  ⏭  No packages created — workspace: not added to pubspec.yaml',
    );
    return;
  }

  final content = File('pubspec.yaml').readAsStringSync();
  final missing = [
    for (final name in packageNames)
      if (!RegExp(
        '^\\s+-\\s+packages/$name\\s*\$',
        multiLine: true,
      ).hasMatch(content))
        name,
  ];
  if (missing.isEmpty) {
    stdout.writeln('  ⏭  Skipped (exists): workspace entries');
    return;
  }

  final entries = missing.map((n) => '  - packages/$n\n').join();
  final workspace = RegExp(r'^workspace:[ \t]*\n', multiLine: true);
  final updated = workspace.hasMatch(content)
      ? content.replaceFirstMapped(workspace, (m) => '${m[0]}$entries')
      : content.replaceFirst(
          RegExp(r'^dependencies:', multiLine: true),
          'workspace:\n$entries\ndependencies:',
        );

  overwriteFile('pubspec.yaml', updated);
  stdout.writeln(
    '📋 Workspace entries added to pubspec.yaml (${missing.join(', ')})',
  );
}
