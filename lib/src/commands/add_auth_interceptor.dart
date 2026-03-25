import 'dart:io';

import '../functions/auth_interceptor/generate_auth_interceptor.dart';
import '../functions/auth_interceptor/patch_di_keys.dart';
import '../functions/auth_interceptor/patch_network_module.dart';
import '../functions/init/run_dart_format.dart';
import '../functions/shared/ensure_pubspec.dart';

void addAuthInterceptor() {
  ensurePubspec();

  stdout.writeln('🔐 Scaffolding auth interceptor...');

  generateAuthInterceptor();
  patchDiKeys();
  patchNetworkModule();
  runDartFormat();

  stdout.writeln();
  stdout.writeln('✅ Auth interceptor scaffold generated.');
  stdout.writeln();
  stdout.writeln('Next steps:');
  stdout.writeln(
    '  1. Fill in the TODOs in lib/core/network/interceptors/auth_interceptor.dart',
  );
  stdout.writeln('  2. Run: clean-helper build_runner build');
}
