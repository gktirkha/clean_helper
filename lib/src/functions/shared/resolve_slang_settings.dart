import 'package_configs.dart';

/// The localization package's slang settings: the defaults below, overridden
/// and extended by the slang keys under `clean-helper.packages.localization`.
/// Key order is kept so `slang.yaml` reads the same as before.
Map<String, String> resolveSlangSettings() => {
  'base_locale': 'en',
  'fallback_strategy': 'base_locale',
  'input_directory': 'assets/locales',
  'input_file_pattern': '.locale.json',
  'output_directory': 'lib/src/generated',
  'output_file_name': 'locales.g.dart',
  'translate_var': 'locales',
  ...slangSettingsConfig,
};
