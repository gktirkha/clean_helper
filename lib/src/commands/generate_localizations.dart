import 'dart:io';

import '../functions/init/run_slang.dart';
import '../functions/shared/abort.dart';
import '../functions/shared/ensure_pubspec.dart';
import '../functions/shared/resolve_localization_package.dart';

/// Runs slang in `packages/<localization>`, where `slang.yaml` lives.
void runGenerateLocalizationsCommand() {
  ensurePubspec();
  final localization = resolveLocalizationPackage().name;
  if (!Directory('packages/$localization').existsSync()) {
    abort(
      'packages/$localization not found. The localization package lives '
      'elsewhere in the workspace — run `dart run slang` there.',
    );
  }
  runSlang(localization);
}
