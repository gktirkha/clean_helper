import 'dart:io';

import '../functions/config/add_config_to_pubspec.dart';
import '../functions/shared/abort.dart';

// Does NOT call ensurePubspec() — the config belongs in the pubspec of the
// current directory (the monorepo root in a monorepo), and ensurePubspec()
// would switch into an app first.

/// Appends a commented `clean-helper:` block with every config key to
/// `./pubspec.yaml`.
void addConfig() {
  if (!File('pubspec.yaml').existsSync()) {
    abort('pubspec.yaml not found. Run this tool from the project root.');
  }

  stdout.writeln('🚀 Adding clean-helper config to pubspec.yaml...');
  addConfigToPubspec();
  stdout.writeln();
  stdout.writeln(
    '✅ Done. Active values are the defaults; uncomment and edit the rest.',
  );
}
