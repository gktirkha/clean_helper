import 'dart:io';

import 'abort.dart';

String readPackageName() {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    abort('pubspec.yaml not found. Run this tool from the project root.');
  }
  final lines = pubspec.readAsLinesSync();
  for (final line in lines) {
    if (line.startsWith('name:')) {
      return line.split(':').last.trim();
    }
  }
  abort('Could not read package name from pubspec.yaml.');
}
