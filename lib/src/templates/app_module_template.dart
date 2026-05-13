String appModuleTemplate() => '''
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@module
abstract class AppModule {
  @lazySingleton
  GlobalKey<NavigatorState> get navigationKey => GlobalKey<NavigatorState>();

  @lazySingleton
  GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey =>
      GlobalKey<ScaffoldMessengerState>();

  @lazySingleton
  Logger get logger => Logger();
}
''';
