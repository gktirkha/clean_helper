import 'package_configs.dart';

/// The call adapter class name: `packages.utils.call_adapter_name`, else
/// `retrofit_call_adapter.name`, else `RetrofitCallAdapter`.
String resolveCallAdapterName() =>
    callAdapterNameConfig ??
    retrofitCallAdapterConfig?.name ??
    'RetrofitCallAdapter';
