import 'dart:io';

import '../functions/shared/abort.dart';
import '../functions/shared/read_mono_repo_apps.dart';

// Does NOT call ensurePubspec() — that would trigger project selection before
// we can print the list. Pubspec presence is checked directly instead.
void listMonoRepoApps() {
  if (!File('pubspec.yaml').existsSync()) {
    abort('pubspec.yaml not found. Run this tool from the project root.');
  }

  final apps = readMonoRepoApps();

  if (apps == null) {
    stdout.writeln('No mono-repo apps configured.');
    stdout.writeln(
      'Add a clean-helper section to pubspec.yaml to declare your apps:',
    );
    stdout.writeln();
    stdout.writeln('  clean-helper:');
    stdout.writeln('    mono_repo_apps:');
    stdout.writeln('      - apps/app1');
    stdout.writeln('      - apps/app2');
    return;
  }

  stdout.writeln('Detected mono-repo apps (${apps.length}):');
  for (var i = 0; i < apps.length; i++) {
    final label = apps[i].split('/').last;
    stdout.writeln('  ${i + 1}. $label  (${apps[i]})');
  }
}
