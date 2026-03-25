import 'dart:io';

import '../shared/insert_after_last_import.dart';

void patchNetworkModule() {
  const path = 'lib/core/network/di/network_module.dart';
  final file = File(path);

  if (!file.existsSync()) {
    stderr.writeln('  ⚠️  $path not found — skipping network module patch.');
    return;
  }

  var content = file.readAsStringSync();
  var changed = false;

  const authImport = "import '../interceptors/auth_interceptor.dart';";
  const diKeysImport = "import '../../../core/di/di_keys.dart';";

  if (!content.contains('auth_interceptor.dart')) {
    content = insertAfterLastImport(content, authImport);
    changed = true;
  }

  if (!content.contains('di_keys.dart')) {
    content = insertAfterLastImport(content, diKeysImport);
    changed = true;
  }

  if (!content.contains('AuthInterceptor authInterceptor')) {
    content = content.replaceFirst(
      RegExp(r'(@lazySingleton\s+Dio dio\()'),
      '@lazySingleton\n  Dio dio(\n    AuthInterceptor authInterceptor,',
    );
    content = content.replaceFirst(
      RegExp(r'(\.\.interceptors\.addAll\(\[)(\s+)(prettyDioLogger,)'),
      '..interceptors.addAll([\n      authInterceptor,\n      prettyDioLogger,',
    );
    changed = true;
  }

  if (!content.contains('noAuthDio')) {
    const noAuthDioMethod = '''

  @lazySingleton
  @Named(DIKeys.noAuthDio)
  Dio noAuthDio(
    BaseOptions baseOptions,
    PrettyDioLogger prettyDioLogger,
    ChuckerDioInterceptor chuckerDioInterceptor,
    ErrorInterceptor errorInterceptor,
  ) => Dio(baseOptions)
    ..interceptors.addAll([
      prettyDioLogger,
      chuckerDioInterceptor,
      errorInterceptor,
    ]);''';

    final lastBrace = content.lastIndexOf('}');
    content =
        '${content.substring(0, lastBrace)}$noAuthDioMethod\n${content.substring(lastBrace)}';
    changed = true;
  }

  if (changed) {
    file.writeAsStringSync(content);
    stdout.writeln('  ✏️  Patched: $path');
  } else {
    stdout.writeln('  ⏭  Network module already configured — skipped.');
  }
}
