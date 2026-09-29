import 'dart:io';

/// Warns if the app's `pubspec.yaml` lacks the packages the generated REST
/// datasource needs. `add-network-module` installs them in a single-app
/// project, but with an external network package the app must add them itself.
void warnMissingRestDependencies() {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) return;

  final content = pubspec.readAsStringSync();
  final missing = ['dio', 'retrofit', 'retrofit_generator']
      .where((dep) => !RegExp('^\\s+$dep:', multiLine: true).hasMatch(content))
      .toList();
  if (missing.isEmpty) return;

  stderr.writeln(
    '  ⚠️  pubspec.yaml is missing ${missing.join(', ')} — the REST '
    'datasource will not compile or generate without them.',
  );
  stderr.writeln(
    '     Add them with: flutter pub add dio retrofit '
    'dev:retrofit_generator',
  );
}
