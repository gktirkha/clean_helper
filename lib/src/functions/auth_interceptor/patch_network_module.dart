import 'dart:io';

import '../shared/insert_after_last_import.dart';
import '../shared/write_file.dart';
import '../../templates/no_auth_dio_method_template.dart';

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
  const diKeysImport = "import '../../di/di_keys.dart';";

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
    content = content.replaceFirstMapped(
      RegExp(r'(\.\.interceptors\.addAll\(\[)(\s*)'),
      (m) => '${m[1]}${m[2]}authInterceptor,${m[2]}',
    );
    changed = true;
  }

  if (!content.contains('noAuthDio')) {
    final noAuthDioMethod = noAuthDioMethodTemplate();
    final lastBrace = content.lastIndexOf('}');
    content =
        '${content.substring(0, lastBrace)}$noAuthDioMethod\n${content.substring(lastBrace)}';
    changed = true;
  }

  if (changed) {
    overwriteFile(path, content);
    stdout.writeln('  ✏️  Patched: $path');
  } else {
    stdout.writeln('  ⏭  Network module already configured — skipped.');
  }
}
