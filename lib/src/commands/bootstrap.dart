import 'dart:io';

import '../functions/init/run_build_runner.dart';
import '../functions/init/run_flutter_pub_get.dart';
import '../functions/init/run_slang.dart';
import '../functions/shared/ensure_pubspec.dart';
import '../functions/shared/fvm_use.dart';
import '../functions/shared/resolve_localization_package.dart';

Future<void> runBootstrapCommand() async {
  ensurePubspec();
  await fvmUse();
  runFlutterPubGet();
  final localization = resolveLocalizationPackage().name;
  if (Directory('packages/$localization').existsSync()) {
    runSlang(localization);
  } else {
    stdout.writeln(
      '  ⏭  packages/$localization not found — skipping slang '
      '(the package lives elsewhere in the workspace).',
    );
  }
  runBuildRunner();
}
