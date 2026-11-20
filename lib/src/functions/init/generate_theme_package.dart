import 'dart:io';

import '../../templates/theme_adaptive_color_template.dart';
import '../../templates/theme_data_template.dart';
import '../../templates/theme_lib_export_template.dart';
import '../../templates/theme_material_theme_template.dart';
import '../../templates/theme_pubspec_tail_template.dart';
import '../../templates/theme_resolver_template.dart';
import '../../templates/theme_scope_template.dart';
import '../../templates/theme_widget_template.dart';
import '../shared/package_barrel_path.dart';
import '../shared/package_barrel_prefix.dart';
import '../shared/package_configs.dart';
import '../shared/theme_base.dart';
import '../shared/write_file.dart';
import 'patch_package_pubspec.dart';
import 'scaffold_package.dart';

/// Creates the theme package in `<parentDir>/<name>`: adaptive light / dark
/// design tokens (`<Base>ThemeData`, `AdaptiveColor`), `<Base>Theme` above
/// `MaterialApp`, the `ThemeResolver` and the mapping to Material
/// `ThemeData`. `<Base>` comes from the package name without `_theme`.
void generateThemePackage(
  PackageConfig package, {
  String parentDir = 'packages',
}) {
  final dir = '$parentDir/${package.name}';
  final base = themeBase(package);
  stdout.writeln('📦 Creating ${package.name} package...');

  scaffoldPackage(package, parentDir: parentDir);
  patchPackagePubspec(dir, themePubspecTailTemplate());

  overwriteFile(
    packageBarrelPath(package, parentDir),
    themeLibExportTemplate(base, packageBarrelPrefix(package)),
  );
  overwriteFile(
    '$dir/lib/src/adaptive_color.dart',
    themeAdaptiveColorTemplate(),
  );
  overwriteFile(
    '$dir/lib/src/theme_manager/theme_resolver.dart',
    themeResolverTemplate(),
  );
  overwriteFile(
    '$dir/lib/src/${base}_material_theme.dart',
    themeMaterialThemeTemplate(base),
  );
  overwriteFile('$dir/lib/src/${base}_theme.dart', themeWidgetTemplate(base));
  overwriteFile(
    '$dir/lib/src/${base}_theme_data.dart',
    themeDataTemplate(base),
  );
  overwriteFile(
    '$dir/lib/src/${base}_theme_scope.dart',
    themeScopeTemplate(base),
  );

  stdout.writeln('📦 ${package.name} package created');
  stdout.writeln();
}
