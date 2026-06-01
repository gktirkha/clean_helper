String getUseCaseParamsTemplate(String className) => '''
class Get${className}Params {
  Get${className}Params({required this.get${className}Param});

  final String get${className}Param;
}
''';
