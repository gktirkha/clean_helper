import '../functions/shared/kebab_case.dart';

String featureRoutesTemplate(String feature, String className) =>
    '''
sealed class ${className}Routes {
  static const String $feature = '/${kebabCase(feature)}';
}
''';
