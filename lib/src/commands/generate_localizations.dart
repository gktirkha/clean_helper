import 'dart:io';

import '../functions/init/run_slang.dart';
import '../functions/shared/abort.dart';
import '../functions/shared/ensure_pubspec.dart';
import '../functions/shared/resolve_localization_package.dart';
import '../functions/shared/resolve_packages_dir.dart';

/// Runs slang in `<foundation.dir>/<localization>`, where `slang.yaml` lives.
void runGenerateLocalizationsCommand() {
  ensurePubspec();
  final packagesDir = resolvePackagesDir();
  final localization = resolveLocalizationPackage().name;
  if (!Directory('$packagesDir/$localization').existsSync()) {
    abort(
      '$packagesDir/$localization not found. The localization package lives '
      'elsewhere in the workspace — run `dart run slang` there.',
    );
  }
  runSlang(localization, parentDir: packagesDir);
}
