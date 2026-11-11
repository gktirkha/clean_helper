String networkPubspecTailTemplate(String utilsPackageName) =>
    '''
resolution: workspace

dependencies:
  dio:
  dio_lens:
  flutter:
    sdk: flutter
  freezed_annotation:
  injectable:
  retrofit:
  $utilsPackageName:

dev_dependencies:
  build_runner:
  flutter_lints:
  freezed:
  injectable_generator:
''';
