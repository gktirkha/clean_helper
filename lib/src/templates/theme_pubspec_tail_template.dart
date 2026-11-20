/// The theme package depends only on Flutter and `material_ui`.
String themePubspecTailTemplate() => '''
resolution: workspace

dependencies:
  flutter:
    sdk: flutter
  material_ui:

dev_dependencies:
  flutter_lints:
''';
