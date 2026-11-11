import '../functions/shared/sort_imports.dart';

/// [utilsPackageModule] is the utils micro-package module injectable
/// generates, `<UtilsPascal>PackageModule`.
String diInitializerTemplate(String utilsImport, String utilsPackageModule) =>
    '''
${sortImports(["import '$utilsImport';", "import 'package:get_it/get_it.dart';", "import 'package:injectable/injectable.dart';"])}

import 'di_initializer.config.dart';

@InjectableInit(
  preferRelativeImports: true,
  externalPackageModulesAfter: [.new($utilsPackageModule)],
)
Future<void> diInitializer(GetIt instance) async {
  await instance.init();
}
''';
