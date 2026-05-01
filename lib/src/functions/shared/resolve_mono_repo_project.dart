import 'dart:io';

import 'abort.dart';
import 'prompt_project_selection.dart';
import 'read_mono_repo_apps.dart';
import 'scope_option.dart';

/// Called by [ensurePubspec] to handle monorepo detection and project selection.
///
/// If a `lib/` folder exists the current directory is a regular Flutter project
/// and this function returns immediately (no-op).
///
/// If `lib/` is absent:
/// - Reads `clean-helper.mono_repo_apps` from `pubspec.yaml`.
/// - If [resolveScope] is set (via `--scope` flag):
///   - Finds all apps whose folder name matches the scope.
///   - Exactly one match → selected automatically.
///   - Multiple matches (same name, different paths) → prompts from that subset.
///   - No match → aborts listing available app names.
/// - If [resolveScope] is null:
///   - One app declared → selected automatically.
///   - Multiple apps → interactive numbered prompt.
/// - If no apps are declared → aborts with setup instructions.
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

  final String selected;
  final scope = resolveScope;

  if (scope != null) {
    final matches =
        apps.where((app) => app.split('/').last == scope).toList();

    if (matches.isEmpty) {
      final available = apps
          .map((a) => '  • ${a.split('/').last}  ($a)')
          .join('\n');
      abort('No mono-repo app named "$scope" found.\nAvailable apps:\n$available');
    } else if (matches.length == 1) {
      selected = matches.first;
    } else {
      selected = promptProjectSelection(
        matches,
        title:
            '⚠️  Multiple apps named "$scope" found. Please select one:',
      );
    }
  } else if (apps.length == 1) {
    selected = apps.first;
  } else {
    selected = promptProjectSelection(apps);
  }

  final appDir = Directory(selected);

  if (!appDir.existsSync()) {
    abort('Project directory not found: $selected');
  }

  stdout.writeln('→ Using project: $selected');
  Directory.current = appDir.path;
}
