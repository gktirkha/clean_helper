/// [moduleName] is the full `@module` class name, e.g. `MyAppUtilsModule`.
String utilsModuleTemplate(String moduleName) =>
    '''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../bloc_observer.dart';

@module
abstract class $moduleName {
  @LazySingleton(as: BlocObserver)
  AppBlocObserver get appBlocObserver => AppBlocObserver();
}
''';
