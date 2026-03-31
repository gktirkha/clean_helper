import 'dart:io';

import '../functions/feature/build_router_module.dart';
import '../functions/init/run_dart_format.dart';
import '../functions/shared/ensure_pubspec.dart';
import '../functions/shared/write_file.dart';

void regenerateRouter() {
  ensurePubspec();

  const routerPath = 'lib/app/router/router_module.dart';
  const featuresDir = 'lib/features';

  final dir = Directory(featuresDir);
  if (!dir.existsSync()) {
    stderr.writeln('⚠️  $featuresDir not found');
    return;
  }

  final features =
      dir
          .listSync()
          .whereType<Directory>()
          .map((d) => d.path.split('/').last)
          .where(
            (name) => File(
              '$featuresDir/$name/router/${name}_router.dart',
            ).existsSync(),
          )
          .toList()
        ..sort();

  if (features.isEmpty) {
    stderr.writeln('⚠️  No features with routers found in $featuresDir');
    return;
  }

  stdout.writeln('🔍 Found routers: ${features.join(', ')}');

  overwriteFile(routerPath, buildRouterModule(features));
  runDartFormat();

  stdout.writeln('✅ router_module.dart regenerated successfully!');
}
