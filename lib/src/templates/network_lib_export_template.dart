/// [prefix] leads from the barrel back to `lib/` (see `packageBarrelPrefix`).
String networkLibExportTemplate(String prefix, {required bool auth}) {
  final exports = [
    "export '${prefix}src/di/di_initializer.module.dart';",
    if (auth) "export '${prefix}src/interceptors/auth_interceptor.dart';",
    "export '${prefix}src/interceptors/error_interceptor.dart';",
    "export '${prefix}src/models/network_config.dart';",
    if (auth) "export '${prefix}src/network_di_keys.dart';",
  ];
  return '${exports.join('\n')}\n';
}
