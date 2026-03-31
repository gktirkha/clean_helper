import 'dart:io';

import '../shared/write_file.dart';
import '../../templates/slang_yaml_template.dart';
import '../../templates/en_locale_template.dart';

void generateLocalizationFiles() {
  writeFile('slang.yaml', slangYamlTemplate());
  writeFile('assets/locales/en.locale.json', enLocaleTemplate());
  stdout.writeln('🌐 Localization files generated');
}
