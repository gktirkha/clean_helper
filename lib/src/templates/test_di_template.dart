/// `test/helpers/test_di.dart`: `testDi()`, which starts DI with the `test`
/// environment for widget and bloc tests.
String testDiTemplate(String appName) =>
    '''
import 'package:$appName/app/di/di_container.dart';
import 'package:$appName/app/di/di_initializer.dart';
import 'package:injectable/injectable.dart' show Environment;

/// Resets DI and registers everything untagged or tagged `@test`. Call it
/// in `setUp` (or `setUpAll`); override a registration afterwards with
/// `diContainer.allowReassignment = true` and `diContainer.registerSingleton`.
Future<void> testDi() async {
  await diContainer.reset();
  await diInitializer(diContainer, environment: Environment.test);
}
''';
