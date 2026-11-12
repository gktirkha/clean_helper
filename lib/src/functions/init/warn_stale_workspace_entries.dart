import 'dart:io';

/// Warns about `workspace:` entries in [pubspec] (plain paths, not globs)
/// whose folder has no `pubspec.yaml` — `pub get` fails on them.
void warnStaleWorkspaceEntries(String pubspec) {
  final block = RegExp(
    r'^workspace:[ \t]*\n((?:[ \t]+-[^\n]*\n?)+)',
    multiLine: true,
  ).firstMatch(pubspec);
  if (block == null) return;

  final stale = [
    for (final line in block[1]!.split('\n'))
      if (RegExp(r'^\s+-\s+(\S+)').firstMatch(line)?[1] case final path?)
        if (!path.contains('*') &&
            !File('${path.replaceFirst(RegExp(r'/+$'), '')}/pubspec.yaml')
                .existsSync())
          path,
  ];
  if (stale.isEmpty) return;

  stderr.writeln(
    '⚠️  workspace: in pubspec.yaml lists folders without a pubspec.yaml: '
    '${stale.join(', ')}. pub get will fail until you remove them.',
  );
}
