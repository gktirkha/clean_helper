String slangYamlTemplate() => '''
base_locale: en
fallback_strategy: base_locale
input_directory: assets/locales
input_file_pattern: .locale.json
output_directory: lib/generated/locales
output_file_name: locales.g.dart
translate_var: locales
''';
