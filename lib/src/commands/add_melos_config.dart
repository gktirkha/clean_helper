import 'dart:io';

import '../functions/melos/add_melos_to_pubspec.dart';
import '../functions/melos/install_melos.dart';
import '../functions/shared/abort.dart';

// Does NOT call ensurePubspec() — melos config belongs in the root pubspec,
// and ensurePubspec() would switch into a monorepo app first.
void addMelosConfig() {
  if (!File('pubspec.yaml').existsSync()) {
    abort('pubspec.yaml not found. Run this tool from the workspace root.');
  }

  stdout.writeln('🚀 Adding melos config to pubspec.yaml...');

  installMelos();
  addMelosToPubspec();

  stdout.writeln();
  stdout.writeln('✅ Melos config added. Run `melos bootstrap` to set up.');
  stdout.writeln();
}
