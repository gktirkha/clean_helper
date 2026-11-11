import 'dart:io';

import '../shared/insert_sorted_import.dart';
import '../shared/write_file.dart';
import '../../templates/dio_lens_init_template.dart';

/// Adds `DioLens.init` after the `Bloc.observer` line of
/// `lib/app/init_service.dart`.
void patchDioLensInit() {
  const path = 'lib/app/init_service.dart';
  final file = File(path);

  if (!file.existsSync()) {
    stderr.writeln('⚠️  $path not found, skipping DioLens.init patch');
    return;
  }

  var content = file.readAsStringSync();

  if (content.contains('DioLens.init(')) {
    stdout.writeln('⏭  DioLens already initialised in $path');
    return;
  }

  final blocObserver = RegExp(
    r'^([ \t]*)Bloc\.observer = diContainer\(\);\n',
    multiLine: true,
  );
  if (!blocObserver.hasMatch(content)) {
    stderr.writeln(
      '⚠️  No `Bloc.observer = diContainer();` line in $path, skipping DioLens.init patch. '
      'Call DioLens.init(navigatorKey: ...) yourself after DI is initialised.',
    );
    return;
  }

  content = content.replaceFirstMapped(
    blocObserver,
    (m) => '${m[0]}${dioLensInitTemplate(m[1]!)}',
  );

  const dioLensImport = "import 'package:dio_lens/dio_lens.dart';";
  if (!content.contains(dioLensImport)) {
    content = insertSortedImport(content, dioLensImport);
  }

  overwriteFile(path, content);
  stdout.writeln('🔍 DioLens.init added to $path');
}
