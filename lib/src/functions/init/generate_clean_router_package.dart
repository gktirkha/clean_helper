import 'dart:io';

import '../../templates/clean_router_base_template.dart';
import '../../templates/clean_router_lib_export_template.dart';
import '../../templates/clean_router_pubspec_tail_template.dart';
import '../../templates/clean_router_refresh_template.dart';
import '../shared/package_barrel_path.dart';
import '../shared/package_barrel_prefix.dart';
import '../shared/package_configs.dart';
import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import 'patch_package_pubspec.dart';
import 'scaffold_package.dart';

/// Creates the router package (`clean_router` by default) from [package]
/// in `<parentDir>/<name>`: `lib/src/<name>_base.dart` (`<NamePascal>Base`)
/// and `lib/src/<name>_refresh.dart` (`<NamePascal>Refresh`).
void generateCleanRouterPackage(
  PackageConfig package, {
  String parentDir = 'packages',
}) {
  final dir = '$parentDir/${package.name}';
  stdout.writeln('📦 Creating ${package.name} package...');

  scaffoldPackage(package, parentDir: parentDir);
  patchPackagePubspec(dir, cleanRouterPubspecTailTemplate());

  overwriteFile(
    packageBarrelPath(package, parentDir),
    cleanRouterLibExportTemplate(package.name, packageBarrelPrefix(package)),
  );
  final prefix = pascalCase(package.name);
  overwriteFile(
    '$dir/lib/src/${package.name}_base.dart',
    cleanRouterBaseTemplate(prefix),
  );
  overwriteFile(
    '$dir/lib/src/${package.name}_refresh.dart',
    cleanRouterRefreshTemplate(prefix),
  );
}
