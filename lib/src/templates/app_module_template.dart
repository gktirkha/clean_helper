String appModuleTemplate() => '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../utils/app_bloc_observer.dart';

@module
abstract class AppModule {
  @lazySingleton
  GlobalKey<NavigatorState> get navigationKey => GlobalKey<NavigatorState>();

  @lazySingleton
  GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey =>
      GlobalKey<ScaffoldMessengerState>();

  @LazySingleton(as: BlocObserver)
  AppBlocObserver get blocObserver => AppBlocObserver();
}
''';
