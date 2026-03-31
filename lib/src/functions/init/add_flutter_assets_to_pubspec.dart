import 'dart:io';

import '../shared/write_file.dart';

void addFlutterAssetsToPubSpec() {
  final content = File('pubspec.yaml').readAsStringSync();

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

  overwriteFile('pubspec.yaml', updated);
  stdout.writeln('📋 Flutter assets added to pubspec.yaml');
}
