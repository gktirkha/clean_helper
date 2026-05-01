import 'dart:io';

/// Reads the `clean-helper.mono_repo_apps` list from pubspec.yaml.
/// Returns null if the section is absent or empty.
List<String>? readMonoRepoApps() {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) return null;

  final lines = pubspec.readAsLinesSync();
  var inCleanHelper = false;
  var inMonoRepoApps = false;
  final apps = <String>[];

  for (final line in lines) {
    final isTopLevel =
        !line.startsWith(' ') && !line.startsWith('\t') && line.isNotEmpty;

    if (isTopLevel) {
      if (line.trimRight() == 'clean-helper:') {
        inCleanHelper = true;
        inMonoRepoApps = false;
        continue;
      } else if (inCleanHelper) {
        break;
      }
    }

    if (inCleanHelper) {
      final trimmed = line.trim();
      if (trimmed == 'mono_repo_apps:') {
        inMonoRepoApps = true;
        continue;
      }
      if (inMonoRepoApps) {
        if (trimmed.startsWith('- ')) {
          apps.add(trimmed.substring(2).trim());
        } else if (trimmed.isNotEmpty &&
            !trimmed.startsWith('#') &&
            !trimmed.startsWith('-')) {
          break;
        }
      }
    }
  }

  return apps.isEmpty ? null : apps;
}
