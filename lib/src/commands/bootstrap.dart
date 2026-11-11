import 'dart:io';

import '../functions/init/run_build_runner.dart';
import '../functions/init/run_flutter_pub_get.dart';
import '../functions/init/run_slang.dart';
import '../functions/shared/ensure_pubspec.dart';
import '../functions/shared/fvm_use.dart';
import '../functions/shared/resolve_localization_package.dart';
import '../functions/shared/resolve_network_package.dart';
import '../functions/shared/resolve_utils_package.dart';

/// `fvm use` → pub get → slang in the localization package → build_runner in
/// the utils and network packages, then the app. Package steps run only for packages under
/// `packages/`; ones elsewhere in the workspace are left to their owner.
Future<void> runBootstrapCommand() async {
  ensurePubspec();
  await fvmUse();
  runFlutterPubGet();

  final localization = resolveLocalizationPackage().name;
  if (Directory('packages/$localization').existsSync()) {
    runSlang(localization);
  } else {
    stdout.writeln('  ⏭  packages/$localization not found — skipping slang');
  }

  // The app's DI config references the packages' micro-package modules,
  // which must be generated first.
  for (final name in [
    resolveUtilsPackage().name,
    resolveNetworkPackage().name,
  ]) {
    if (Directory('packages/$name').existsSync()) {
      runBuildRunner(workingDirectory: 'packages/$name');
    }
  }
  runBuildRunner();
}
