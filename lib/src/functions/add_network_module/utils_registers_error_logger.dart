import 'dart:io';

/// Whether the local utils package's DI module registers `ParseErrorLogger`,
/// as `<app>_utils` did for projects initialised before 1.4.1.
bool utilsRegistersErrorLogger(String utilsPackageName) {
  final module = File(
    'packages/$utilsPackageName/lib/src/di/${utilsPackageName}_module.dart',
  );
  return module.existsSync() &&
      module.readAsStringSync().contains('ParseErrorLogger');
}
