import 'dart:io';

import 'abort.dart';
import 'resolve_mono_repo_project.dart';

/// Aborts with a helpful message if pubspec.yaml is not found in the
/// current directory (i.e. the tool is not run from a Flutter project root).
///
/// After confirming the pubspec exists, calls [resolveMonoRepoProject] to
/// handle monorepo detection: if no lib/ folder is present and the pubspec
/// declares `clean-helper.mono_repo_apps`, the user is prompted to select an
/// app and [Directory.current] is updated accordingly.
void ensurePubspec() {
  if (!File('pubspec.yaml').existsSync()) {
    abort(
      'pubspec.yaml not found. Run this tool from the Flutter project root.',
    );
  }
  resolveMonoRepoProject();
}
