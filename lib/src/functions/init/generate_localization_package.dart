import 'dart:io';

import '../../templates/en_locale_template.dart';
import '../../templates/localization_lib_export_template.dart';
import '../../templates/localization_pubspec_tail_template.dart';
import '../../templates/localization_slang_yaml_template.dart';
import '../../templates/string_extension_template.dart';
import '../shared/abort.dart';
import '../shared/package_barrel_path.dart';
import '../shared/package_barrel_prefix.dart';
import '../shared/package_configs.dart';
import '../shared/write_file.dart';
import 'patch_package_pubspec.dart';
import 'scaffold_package.dart';

/// Creates `<parentDir>/<name>` from [package] and the resolved slang
/// [settings] (see `resolveSlangSettings`).
void generateLocalizationPackage(
  PackageConfig package,
  Map<String, String> settings, {
  String parentDir = 'packages',
}) {
  final dir = '$parentDir/${package.name}';

  final outputDir = settings['output_directory']!;
  if (!outputDir.startsWith('lib/')) {
    abort(
      'packages.localization.output_directory must be inside lib/ '
      '(got "$outputDir").',
    );
  }
  final generatedFile =
      '${outputDir.substring('lib/'.length)}/${settings['output_file_name']}';

  stdout.writeln('📦 Creating ${package.name} package...');
  scaffoldPackage(package, parentDir: parentDir);
  patchPackagePubspec(dir, localizationPubspecTailTemplate());

  overwriteFile(
    packageBarrelPath(package, parentDir),
    localizationLibExportTemplate(generatedFile, packageBarrelPrefix(package)),
  );
  overwriteFile(
    '$dir/lib/src/string_extension.dart',
    stringExtensionTemplate(generatedFile, settings['translate_var']!),
  );
  overwriteFile('$dir/slang.yaml', localizationSlangYamlTemplate(settings));
  overwriteFile(
    '$dir/${settings['input_directory']}/'
    '${settings['base_locale']}${settings['input_file_pattern']}',
    enLocaleTemplate(),
  );

  stdout.writeln('📦 ${package.name} package created');
  stdout.writeln();
}
