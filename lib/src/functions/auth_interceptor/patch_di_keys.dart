import 'dart:io';

import '../shared/write_file.dart';

void patchDiKeys() {
  const path = 'lib/core/di/di_keys.dart';
  final file = File(path);

  if (!file.existsSync()) {
    writeFile(path, '''
sealed class DIKeys {
  static const String noAuthDio = 'noAuthDio';
}
''');
    return;
  }

  final content = file.readAsStringSync();

  if (content.contains('noAuthDio')) {
    stdout.writeln('  ⏭  DIKeys.noAuthDio already present — skipped.');
    return;
  }

  final patched = content.replaceFirstMapped(
    RegExp(r'(sealed class DIKeys \{)([^}]*)(\})'),
    (m) =>
        '${m[1]}${m[2]}  static const String noAuthDio = \'noAuthDio\';\n${m[3]}',
  );

  overwriteFile(path, patched);
  stdout.writeln('  ✏️  Patched: $path');
}
