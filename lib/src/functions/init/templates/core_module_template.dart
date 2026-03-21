String coreModuleTemplate() => '''
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

@module
abstract class CoreModule {
  @lazySingleton
  GlobalKey<NavigatorState> get navigationKey => GlobalKey<NavigatorState>();

  @lazySingleton
  GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey =>
      GlobalKey<ScaffoldMessengerState>();

  @preResolve
  @lazySingleton
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();
}
''';
