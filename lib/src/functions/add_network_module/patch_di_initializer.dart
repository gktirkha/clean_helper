import 'dart:io';

import '../shared/insert_sorted_import.dart';
import '../shared/write_file.dart';

/// Adds `.new([packageModule])` to `externalPackageModulesAfter` in
/// `lib/app/di/di_initializer.dart`, and [packageImport] to its imports.
void patchDiInitializer(String packageImport, String packageModule) {
  const path = 'lib/app/di/di_initializer.dart';
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('⚠️  $path not found — add .new($packageModule) yourself');
    return;
  }

  var content = file.readAsStringSync();
  if (content.contains('.new($packageModule)')) {
    stdout.writeln('  ⏭  $packageModule already in $path');
    return;
  }

  final modules = RegExp(r'externalPackageModulesAfter:\s*\[([^\]]*)\]');
  final match = modules.firstMatch(content);
  if (match == null) {
    stderr.writeln(
      '⚠️  No externalPackageModulesAfter list in $path — '
      'add .new($packageModule) yourself',
    );
    return;
  }

  final entries = [
    ...match[1]!.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty),
    '.new($packageModule)',
  ];
  content = content.replaceRange(
    match.start,
    match.end,
    'externalPackageModulesAfter: [\n'
    '${entries.map((e) => '    $e,\n').join()}'
    '  ]',
  );
  final importLine = "import '$packageImport';";
  if (!content.contains(importLine)) {
    content = insertSortedImport(content, importLine);
  }

  overwriteFile(path, content);
  stdout.writeln('🔗 $packageModule registered in $path');
}
