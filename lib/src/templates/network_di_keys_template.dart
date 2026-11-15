import '../functions/shared/camel_case.dart';

/// `lib/src/network_di_keys.dart` in the network package: names of its
/// `BaseOptions` (`<networkCamel>BaseOptions`, so an app can register its own
/// unnamed `BaseOptions`) and extra Dio instances. `noAuthDio` exists only
/// with [auth].
String networkDiKeysTemplate(String packageName, {required bool auth}) {
  final noAuthDio = auth
      ? "\n  static const String noAuthDio = 'noAuthDio';"
      : '';
  return '''
sealed class NetworkDIKeys {
  static const String baseOptions = '${camelCase(packageName)}BaseOptions';$noAuthDio
  static const String noBaseOptionsDio = 'noBaseOptionsDio';
}
''';
}
