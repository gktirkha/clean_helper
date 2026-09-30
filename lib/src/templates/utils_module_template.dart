String utilsModuleTemplate(String className) =>
    '''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../bloc_observer.dart';

@module
abstract class ${className}Module {
  @LazySingleton(as: BlocObserver)
  AppBlocObserver get appBlocObserver => AppBlocObserver();
}
''';
