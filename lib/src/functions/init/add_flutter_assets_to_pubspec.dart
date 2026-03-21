import 'dart:io';

void addFlutterAssetsToPubSpec() {
  final pubspec = File('pubspec.yaml');
  final content = pubspec.readAsStringSync();

  if (content.contains('assets/colors') && content.contains('assets/locales')) {
    stdout.writeln('  ⏭  Skipped (exists): flutter assets in pubspec.yaml');
    return;
  }

  final updated = content.replaceFirst(
    RegExp(r'(^flutter:\s*$)', multiLine: true),
    '''flutter:
  assets:
    - assets/colors/
    - assets/locales/
''',
  );

  pubspec.writeAsStringSync(updated);
  stdout.writeln('📋 Flutter assets added to pubspec.yaml');
}
