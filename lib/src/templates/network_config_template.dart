/// `lib/src/models/network_config.dart` in the network package: the freezed
/// configuration every app registers in DI.
String networkConfigTemplate() => r'''
import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_config.freezed.dart';

/// Host-provided configuration for the shared network layer.
///
/// Every app must register a [NetworkConfig] in its DI container, e.g.:
///
/// ```dart
/// @module
/// abstract class NetworkConfigModule {
///   @lazySingleton
///   NetworkConfig get networkConfig =>
///       const NetworkConfig(baseUrl: 'https://api.example.com/');
/// }
/// ```
@freezed
sealed class NetworkConfig with _$NetworkConfig {
  const factory NetworkConfig({
    required String baseUrl,
    @Default(Duration(seconds: 30)) Duration connectTimeout,
    @Default(Duration(seconds: 30)) Duration receiveTimeout,
    @Default(Duration(minutes: 5)) Duration sendTimeout,

    /// Default headers sent with every request (e.g. `User-Agent`).
    @Default(<String, Object?>{}) Map<String, Object?> headers,
  }) = _NetworkConfig;
}
''';
