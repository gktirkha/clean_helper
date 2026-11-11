import 'dart:io';

import '../../templates/clean_router_base_template.dart';
import '../../templates/clean_router_lib_export_template.dart';
import '../../templates/clean_router_pubspec_tail_template.dart';
import '../../templates/clean_router_refresh_template.dart';
import '../shared/package_barrel_path.dart';
import '../shared/package_barrel_prefix.dart';
import '../shared/package_configs.dart';
import '../shared/write_file.dart';
import 'patch_package_pubspec.dart';
import 'scaffold_package.dart';

/// Creates the router package (`clean_router` by default) from [package].
void generateCleanRouterPackage(PackageConfig package) {
  final dir = 'packages/${package.name}';
  stdout.writeln('📦 Creating ${package.name} package...');

  scaffoldPackage(package);
  patchPackagePubspec(dir, cleanRouterPubspecTailTemplate());

  overwriteFile(
    packageBarrelPath(package),
    cleanRouterLibExportTemplate(packageBarrelPrefix(package)),
  );
  overwriteFile(
    '$dir/lib/src/clean_router_base.dart',
    cleanRouterBaseTemplate(),
  );
  overwriteFile(
    '$dir/lib/src/clean_router_refresh.dart',
    cleanRouterRefreshTemplate(),
  );
}
