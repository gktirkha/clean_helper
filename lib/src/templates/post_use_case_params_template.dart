String postUseCaseParamsTemplate(String className) =>
    '''
class Post${className}Params {
  Post${className}Params({required this.post${className}Param1});

  final String post${className}Param1;
}
''';
