import 'dart:io';

import '../shared/write_file.dart';

void generateLocalizationFiles() {
  writeFile('slang.yaml', '''
base_locale: en
fallback_strategy: base_locale
input_directory: assets/locales
input_file_pattern: .locale.json
output_directory: lib/generated/locales
output_file_name: locales.g.dart
translate_var: locales
''');

  writeFile('assets/locales/en.locale.json', '''
{
  "general": {
    "languageName": "English"
  }
}
''');

  stdout.writeln('🌐 Localization files generated');
}
