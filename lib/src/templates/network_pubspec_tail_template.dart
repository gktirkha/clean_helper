/// The network package depends on nothing in the workspace.
String networkPubspecTailTemplate() => '''
resolution: workspace

dependencies:
  dio:
  dio_lens:
  flutter:
    sdk: flutter
  freezed_annotation:
  injectable:
  retrofit:

dev_dependencies:
  build_runner:
  flutter_lints:
  freezed:
  injectable_generator:
''';
