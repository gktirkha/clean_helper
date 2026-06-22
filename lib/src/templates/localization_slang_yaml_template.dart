import 'slang_yaml_template.dart';

String localizationSlangYamlTemplate() => slangYamlTemplate().replaceFirst(
  'output_directory: lib/generated/locales',
  'output_directory: lib/src/generated',
);
