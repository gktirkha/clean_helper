import 'dart:io';

import '../../templates/clean_helper_config_template.dart';
import '../shared/tool_version.dart';
import '../shared/write_file.dart';
import 'find_mono_repo_apps.dart';

/// Appends the commented `clean-helper:` template to `./pubspec.yaml`, unless
/// it already has a top-level `clean-helper:` key.
void addConfigToPubspec() {
  final content = File('pubspec.yaml').readAsStringSync();

  if (RegExp(r'^clean-helper:', multiLine: true).hasMatch(content)) {
    stdout.writeln(
      '  ⏭  Skipped (exists): clean-helper config in pubspec.yaml — '
      'see the README for every key',
    );
    return;
  }

  final apps = findMonoRepoApps();
  overwriteFile(
    'pubspec.yaml',
    '${content.trimRight()}\n'
        '${cleanHelperConfigTemplate(version: toolVersion, apps: apps)}',
  );
  stdout.writeln(
    '  📄 clean-helper config added to pubspec.yaml'
    '${apps.isEmpty ? '' : ' (mono_repo_apps: ${apps.join(', ')})'}',
  );
}
