import 'package_configs.dart';
import 'pascal_case.dart';

/// The utils package's `@module` class: `packages.utils.module_name`, else
/// `<UtilsPascal>Module`.
String resolveUtilsModuleName(PackageConfig utils) =>
    utilsModuleNameConfig ?? '${pascalCase(utils.name)}Module';
