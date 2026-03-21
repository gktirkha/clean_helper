import 'dart:io';

import 'abort.dart';

/// Aborts with a helpful message if pubspec.yaml is not found in the
/// current directory (i.e. the tool is not run from a Flutter project root).
void ensurePubspec() {
  if (!File('pubspec.yaml').existsSync()) {
    abort(
      'pubspec.yaml not found. Run this tool from the Flutter project root.',
    );
  }
}
