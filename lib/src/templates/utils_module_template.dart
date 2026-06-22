String utilsModuleTemplate(String className) =>
    '''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';

import '../bloc_observer.dart';
import '../network/retrofit_logger.dart';

@module
abstract class ${className}Module {
  @LazySingleton(as: BlocObserver)
  AppBlocObserver get appBlocObserver => AppBlocObserver();

  @LazySingleton(as: ParseErrorLogger)
  RetrofitLogger get retrofitLogger => RetrofitLogger();
}
''';
