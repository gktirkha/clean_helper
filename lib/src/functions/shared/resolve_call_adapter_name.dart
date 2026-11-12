import 'package_configs.dart';

/// The app's Retrofit call adapter class: `packages.network.call_adapter_name`,
/// else `AppCallAdapter`.
String resolveCallAdapterName() => callAdapterNameConfig ?? 'AppCallAdapter';
