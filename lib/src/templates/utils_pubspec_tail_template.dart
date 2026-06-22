String utilsPubspecTailTemplate(String localizationPackageName) => '''
resolution: workspace

dependencies:
  dio:
  flutter:
    sdk: flutter
  flutter_bloc:
  fpdart:
  injectable:
  logger:
  $localizationPackageName:
  retrofit:

dev_dependencies:
  build_runner:
  flutter_lints:
  injectable_generator:
''';
