String getUseCaseParamsTemplate(String className) =>
    '''
class Get${className}Params {
  Get${className}Params({required this.get${className}Query});

  final String get${className}Query;
}
''';
