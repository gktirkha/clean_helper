/// A workspace package declared under `clean-helper.packages.<key>` in the
/// pubspec the command was started from.
///
/// [import] is the barrel import URI, e.g. `package:my_utils/my_utils.dart`.
typedef PackageConfig = ({String name, String import});

/// `clean-helper.packages.utils`, set by [loadPackageConfigs].
/// Null means the legacy `<app>_utils` package is used.
PackageConfig? utilsPackageConfig;

/// `clean-helper.packages.network`, set by [loadPackageConfigs].
/// Null means networking is detected from `lib/core/network/`.
PackageConfig? networkPackageConfig;

/// `clean-helper.retrofit_call_adapter`, set by [loadPackageConfigs].
/// [name] is the adapter class; a null [import] means it comes from the
/// network package, or the utils package when no network package is set.
/// Null means `RetrofitCallAdapter` from those same imports.
({String name, String? import})? retrofitCallAdapterConfig;

/// `clean-helper.result_type` (`task_either` or `future_either`), set by
/// [loadPackageConfigs]. Null means `task_either`.
String? resultTypeConfig;
