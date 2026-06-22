import 'dart:io';

import '../../templates/analysis_options_template.dart';
import '../../templates/en_locale_template.dart';
import '../../templates/localization_lib_export_template.dart';
import '../../templates/localization_pubspec_tail_template.dart';
import '../../templates/slang_yaml_template.dart';
import '../../templates/string_extension_template.dart';
import '../shared/run_command.dart';
import '../shared/write_file.dart';

void generateLocalizationPackage(String localizationPackageName) {
  stdout.writeln('📦 Creating $localizationPackageName package...');

  runCommand([
    'flutter',
    'create',
    'packages/$localizationPackageName',
    '--template',
    'package',
  ]);

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

  _patchLocalizationPubspec(localizationPackageName);

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
    _localizationSlangYamlTemplate(),
  );
  overwriteFile(
    'packages/$localizationPackageName/assets/locales/en.locale.json',
    enLocaleTemplate(),
  );

  stdout.writeln('📦 $localizationPackageName package created');
  stdout.writeln();
}

String _localizationSlangYamlTemplate() => slangYamlTemplate().replaceFirst(
  'output_directory: lib/generated/locales',
  'output_directory: lib/src/generated',
);

void _patchLocalizationPubspec(String localizationPackageName) {
  final file = File('packages/$localizationPackageName/pubspec.yaml');
  final lines = file.readAsLinesSync();

  final noComments = lines.where((l) => !l.trimLeft().startsWith('#')).toList();

  final envStart = noComments.indexWhere((l) => l.startsWith('environment:'));
  var envEnd = envStart + 1;
  while (envEnd < noComments.length) {
    final line = noComments[envEnd];
    if (line.isNotEmpty && !line.startsWith(' ') && !line.startsWith('\t')) {
      break;
    }
    envEnd++;
  }

  final header = noComments.sublist(0, envEnd).join('\n').trimRight();

  overwriteFile(
    'packages/$localizationPackageName/pubspec.yaml',
    '$header\n\n${localizationPubspecTailTemplate()}',
  );
}
