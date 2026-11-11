String networkDiKeysTemplate() => '''
sealed class NetworkDIKeys {
  /// [Dio] instance without [AuthInterceptor], used for token refresh and
  /// unauthenticated endpoints.
  static const String noAuthDio = 'noAuthDio';
}
''';
