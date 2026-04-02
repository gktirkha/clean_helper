String coreModuleTemplate() => '''
import 'package:injectable/injectable.dart';
import 'package:logger/web.dart';
import 'package:package_info_plus/package_info_plus.dart';

@module
abstract class CoreModule {
  @preResolve
  @lazySingleton
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();

  @lazySingleton
  Logger get logger => Logger();
}
''';
