import '../functions/shared/camel_case.dart';
import '../functions/shared/kebab_case.dart';

String featureRoutesTemplate(String feature, String className) =>
    '''
sealed class ${className}Routes {
  static const String ${camelCase(feature)} = '/${kebabCase(feature)}';
}
''';
