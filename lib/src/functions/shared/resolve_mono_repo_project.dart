import 'dart:io';

import 'abort.dart';
import 'prompt_project_selection.dart';
import 'read_mono_repo_apps.dart';

/// Called by [ensurePubspec] to handle monorepo detection and project selection.
///
/// If a `lib/` folder exists the current directory is a regular Flutter project
/// and this function returns immediately (no-op).
///
/// If `lib/` is absent:
/// - Reads `clean-helper.mono_repo_apps` from `pubspec.yaml`.
/// - If the list is present, prompts the user to select a project and changes
///   [Directory.current] to the chosen app directory so all subsequent
///   relative-path operations target the correct project.
/// - If the list is absent, aborts with instructions to declare the apps.
void resolveMonoRepoProject() {
  if (Directory('lib').existsSync()) return;

  final apps = readMonoRepoApps();

  if (apps == null) {
    abort(
      'No lib/ folder found in the current directory.\n'
      'If this is a monorepo root, declare your apps in pubspec.yaml:\n'
      '\n'
      '  clean-helper:\n'
      '    mono_repo_apps:\n'
      '      - apps/app1\n'
      '      - apps/app2\n'
      '\n'
      'Then re-run the command from the monorepo root.',
    );
  }

  final selected = promptProjectSelection(apps);
  final appDir = Directory(selected);

  if (!appDir.existsSync()) {
    abort('Project directory not found: $selected');
  }

  stdout.writeln('→ Using project: $selected');
  Directory.current = appDir.path;
}
