import 'read_package_name.dart';

/// `lib/app/router/<app>_router_module.dart` for the app in the current
/// directory — the tool-owned module listing every feature router.
String appRouterModulePath() =>
    'lib/app/router/${readPackageName()}_router_module.dart';
