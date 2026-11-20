/// The utils package depends on no other workspace package.
String utilsPubspecTailTemplate() => '''
resolution: workspace

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc:
  fpdart:
  get_it:
  injectable:
  logger:
  material_ui:

dev_dependencies:
  build_runner:
  flutter_lints:
  injectable_generator:
''';
