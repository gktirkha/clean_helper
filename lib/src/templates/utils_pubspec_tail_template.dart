String utilsPubspecTailTemplate(String localizationPackageName) =>
    '''
resolution: workspace

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc:
  fpdart:
  get_it:
  injectable:
  logger:
  $localizationPackageName:

dev_dependencies:
  build_runner:
  flutter_lints:
  injectable_generator:
''';
