import 'dart:io';

import '../init/write_tool_version.dart';
import 'package_configs.dart';
import 'read_clean_helper_fields.dart';

/// In a monorepo app, copies the workspace root's `clean-helper.version` into
/// the app's pubspec when they differ, so the root is the one place to bump
/// it. Does nothing outside a monorepo app or when the root has no version.
void syncAppToolVersion() {
  final rootVersion = rootToolVersionConfig;
  if (monoRepoAppPath == null || rootVersion == null) return;
  if (readCleanHelperFields([])['version'] == rootVersion) return;
  writeToolVersion(rootVersion);
  stdout.writeln(
    '  🔄 Synced $monoRepoAppPath clean-helper.version to $rootVersion '
    '(from the root pubspec)',
  );
}
