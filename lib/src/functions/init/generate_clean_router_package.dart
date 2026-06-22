import 'dart:io';

import '../../templates/analysis_options_template.dart';
import '../../templates/clean_router_base_template.dart';
import '../../templates/clean_router_lib_export_template.dart';
import '../../templates/clean_router_pubspec_tail_template.dart';
import '../../templates/clean_router_refresh_template.dart';
import '../shared/fvm_exec.dart';
import '../shared/run_command.dart';
import '../shared/write_file.dart';
import 'patch_package_pubspec.dart';

void generateCleanRouterPackage() {
  stdout.writeln('📦 Creating clean_router package...');

  runCommand([
    ...fvmExec('flutter'),
    'create',
    'packages/clean_router',
    '--template',
    'package',
  ]);

  // Remove unwanted generated files
  final filesToDelete = [
    'packages/clean_router/.metadata',
    'packages/clean_router/CHANGELOG.md',
    'packages/clean_router/LICENSE',
    'packages/clean_router/README.md',
  ];
  for (final path in filesToDelete) {
    final file = File(path);
    if (file.existsSync()) file.deleteSync();
  }
  final testDir = Directory('packages/clean_router/test');
  if (testDir.existsSync()) testDir.deleteSync(recursive: true);

  // Overwrite analysis_options.yaml
  overwriteFile(
    'packages/clean_router/analysis_options.yaml',
    analysisOptionsTemplate(),
  );

  patchPackagePubspec(
    'packages/clean_router',
    cleanRouterPubspecTailTemplate(),
  );

  // Write lib files
  overwriteFile(
    'packages/clean_router/lib/clean_router.dart',
    cleanRouterLibExportTemplate(),
  );
  overwriteFile(
    'packages/clean_router/lib/src/clean_router_base.dart',
    cleanRouterBaseTemplate(),
  );
  overwriteFile(
    'packages/clean_router/lib/src/clean_router_refresh.dart',
    cleanRouterRefreshTemplate(),
  );
}
