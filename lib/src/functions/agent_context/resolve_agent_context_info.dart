import '../shared/package_configs.dart';
import '../shared/read_mono_repo_apps.dart';
import '../shared/read_package_name.dart';
import '../shared/resolve_call_adapter_name.dart';
import '../shared/resolve_localization_package.dart';
import '../shared/resolve_network_package.dart';
import '../shared/resolve_packages_dir.dart';
import '../shared/resolve_router_package.dart';
import '../shared/resolve_theme_package.dart';
import '../shared/resolve_utils_package.dart';
import 'agent_context_info.dart';

/// [AgentContextInfo] for the pubspec in the current directory. In a
/// monorepo, unconfigured packages are shown as `<app>_<kind>`, because each
/// app has its own default.
AgentContextInfo resolveAgentContextInfo() {
  final apps = readMonoRepoApps() ?? [];
  String name(PackageConfig? configured, String kind, String single) =>
      configured?.name ?? (apps.isEmpty ? single : '<app>_$kind');

  return (
    projectName: readPackageName(),
    apps: apps,
    foundationDir: resolvePackagesDir(),
    utils: name(utilsPackageConfig, 'utils', resolveUtilsPackage().name),
    localization: name(
      localizationPackageConfig,
      'localization',
      resolveLocalizationPackage().name,
    ),
    router: resolveRouterPackage().name,
    theme: name(themePackageConfig, 'theme', resolveThemePackage().name),
    network: name(
      networkPackageConfig,
      'network',
      resolveNetworkPackage().name,
    ),
    callAdapter: resolveCallAdapterName(),
  );
}
