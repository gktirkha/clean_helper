String utilsPubspecTailTemplate(String localizationPackageName) =>
    '''
resolution: workspace

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc:
  fpdart:
  injectable:
  logger:
  $localizationPackageName:

dev_dependencies:
  build_runner:
  flutter_lints:
  injectable_generator:
''';
