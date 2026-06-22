import 'dart:io';

import '../../templates/analysis_options_template.dart';
import '../../templates/en_locale_template.dart';
import '../../templates/localization_lib_export_template.dart';
import '../../templates/localization_pubspec_tail_template.dart';
import '../../templates/localization_slang_yaml_template.dart';
import '../../templates/string_extension_template.dart';
import '../shared/fvm_exec.dart';
import '../shared/run_command.dart';
import '../shared/write_file.dart';
import 'patch_package_pubspec.dart';

void generateLocalizationPackage(String localizationPackageName) {
  stdout.writeln('📦 Creating $localizationPackageName package...');

  runCommand([...fvmExec('flutter'), 'create', 'packages/$localizationPackageName', '--template', 'package']);

  final filesToDelete = [
    'packages/$localizationPackageName/.metadata',
    'packages/$localizationPackageName/CHANGELOG.md',
    'packages/$localizationPackageName/LICENSE',
    'packages/$localizationPackageName/README.md',
  ];
  for (final path in filesToDelete) {
    final file = File(path);
    if (file.existsSync()) file.deleteSync();
  }
  final testDir = Directory('packages/$localizationPackageName/test');
  if (testDir.existsSync()) testDir.deleteSync(recursive: true);

  overwriteFile(
    'packages/$localizationPackageName/analysis_options.yaml',
    analysisOptionsTemplate(),
  );

  patchPackagePubspec(
    'packages/$localizationPackageName',
    localizationPubspecTailTemplate(),
  );

  overwriteFile(
    'packages/$localizationPackageName/lib/$localizationPackageName.dart',
    localizationLibExportTemplate(),
  );
  overwriteFile(
    'packages/$localizationPackageName/lib/src/string_extension.dart',
    stringExtensionTemplate(),
  );
  overwriteFile(
    'packages/$localizationPackageName/slang.yaml',
    localizationSlangYamlTemplate(),
  );
  overwriteFile(
    'packages/$localizationPackageName/assets/locales/en.locale.json',
    enLocaleTemplate(),
  );

  stdout.writeln('📦 $localizationPackageName package created');
  stdout.writeln();
}


