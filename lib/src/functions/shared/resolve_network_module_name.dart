import 'package_configs.dart';
import 'pascal_case.dart';

/// The network package's `@module` class: `packages.network.module_name`,
/// else `<NetworkPascal>Module`.
String resolveNetworkModuleName(PackageConfig network) =>
    networkModuleNameConfig ?? '${pascalCase(network.name)}Module';
