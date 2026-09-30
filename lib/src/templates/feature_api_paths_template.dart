import '../functions/shared/camel_case.dart';
import '../functions/shared/kebab_case.dart';

String featureApiPathsTemplate(
  String className,
  String repoName,
  String feature,
) =>
    '''
sealed class ${className}ApiPaths {
  static const String ${camelCase(repoName)} = '/api/${kebabCase(feature)}/';
}
''';
