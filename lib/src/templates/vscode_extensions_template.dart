import 'dart:convert';

/// Extensions recommended for projects clean_helper generates.
const vscodeRecommendedExtensions = [
  'Dart-Code.dart-code',
  'Dart-Code.flutter',
  'FelixAngelov.bloc',
  'aksharpatel47.vscode-flutter-helper',
  'hzgood.dart-data-class-generator',
  'jeroen-meijer.pubspec-assist',
  'mthuong.vscode-flutter-freezed-helper',
  'plibither8.remove-comments',
  'redhat.vscode-xml',
  'redhat.vscode-yaml',
  'streetsidesoftware.code-spell-checker',
  'usernamehw.errorlens',
];

/// `.vscode/extensions.json` with [recommendations], 4-space indented.
String vscodeExtensionsTemplate(List<String> recommendations) =>
    '${const JsonEncoder.withIndent('    ').convert({'recommendations': recommendations})}\n';
