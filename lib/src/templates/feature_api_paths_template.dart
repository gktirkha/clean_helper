import '../functions/shared/kebab_case.dart';

String featureApiPathsTemplate(
  String className,
  String repoName,
  String feature,
) =>
    '''
sealed class ${className}ApiPaths {
  static const String $repoName = '/api/${kebabCase(feature)}/';
}
''';
