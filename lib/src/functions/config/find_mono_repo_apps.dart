import 'dart:io';

/// App folders under `apps/` that have a `pubspec.yaml`, as relative paths
/// (`apps/<name>`), sorted. Empty when there's no `apps/` folder.
List<String> findMonoRepoApps() {
  final apps = Directory('apps');
  if (!apps.existsSync()) return [];
  return [
    for (final dir in apps.listSync().whereType<Directory>())
      if (File('${dir.path}/pubspec.yaml').existsSync())
        'apps/${dir.uri.pathSegments.where((s) => s.isNotEmpty).last}',
  ]..sort();
}
