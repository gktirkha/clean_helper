String diInitializerTemplate() => '''
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di_initializer.config.dart';

@InjectableInit(preferRelativeImports: true)
Future<void> diInitializer(GetIt instance) async {
  await instance.init();
}
''';
