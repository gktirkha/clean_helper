import 'dart:io';

import '../../templates/analysis_options_template.dart';
import '../../templates/clean_router_base_template.dart';
import '../../templates/clean_router_lib_export_template.dart';
import '../../templates/clean_router_pubspec_tail_template.dart';
import '../../templates/clean_router_refresh_template.dart';
import '../shared/run_command.dart';
import '../shared/write_file.dart';

void generateCleanRouterPackage() {
  stdout.writeln('📦 Creating clean_router package...');

  runCommand([
    'flutter',
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

  // Patch pubspec.yaml: strip comments, keep header + environment, append deps
  _patchCleanRouterPubspec();

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

void _patchCleanRouterPubspec() {
  final file = File('packages/clean_router/pubspec.yaml');
  final lines = file.readAsLinesSync();

  // Strip comment lines
  final noComments = lines.where((l) => !l.trimLeft().startsWith('#')).toList();

  // Find the environment: section and where it ends (next top-level key)
  final envStart = noComments.indexWhere((l) => l.startsWith('environment:'));
  var envEnd = envStart + 1;
  while (envEnd < noComments.length) {
    final line = noComments[envEnd];
    if (line.isNotEmpty && !line.startsWith(' ') && !line.startsWith('\t')) {
      break;
    }
    envEnd++;
  }

  // Keep only the header up to and including the environment section
  final header = noComments.sublist(0, envEnd).join('\n').trimRight();

  overwriteFile(
    'packages/clean_router/pubspec.yaml',
    '$header\n\n${cleanRouterPubspecTailTemplate()}',
  );
}
