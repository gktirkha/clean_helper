String diInitializerTemplate(String utilsPackageName, String utilsClassName) => '''
import 'package:$utilsPackageName/$utilsPackageName.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di_initializer.config.dart';

@InjectableInit(
  preferRelativeImports: true,
  externalPackageModulesAfter: [.new(${utilsClassName}PackageModule)],
)
Future<void> diInitializer(GetIt instance) async {
  await instance.init();
}
''';
