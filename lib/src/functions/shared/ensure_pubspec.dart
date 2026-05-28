import 'dart:io';

import 'abort.dart';
import 'check_version_mismatch.dart';
import 'resolve_mono_repo_project.dart';

void ensurePubspec() {
  if (!File('pubspec.yaml').existsSync()) {
    abort(
      'pubspec.yaml not found. Run this tool from the Flutter project root.',
    );
  }
  resolveMonoRepoProject();
  checkVersionMismatch();
}
