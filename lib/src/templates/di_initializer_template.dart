import '../functions/shared/sort_imports.dart';

/// [utilsPackageModule] is the utils micro-package module injectable
/// generates, `<UtilsPascal>PackageModule`. `add-network-module` adds the
/// network package's module to the same list.
String diInitializerTemplate(String utilsImport, String utilsPackageModule) =>
    '''
${sortImports(["import '$utilsImport';", "import 'package:get_it/get_it.dart';", "import 'package:injectable/injectable.dart';"])}

import 'di_initializer.config.dart';

@InjectableInit(
  preferRelativeImports: true,
  externalPackageModulesAfter: [
    .new($utilsPackageModule),
  ],
)
/// Only registrations that are untagged or tagged with [environment]
/// (`Environment.dev` / `prod` / `test`) are registered.
Future<void> diInitializer(
  GetIt instance, {
  required String environment,
}) async {
  await instance.init(environment: environment);
}
''';
