String featureModuleTemplate(String className, String feature) =>
    '''
import 'package:injectable/injectable.dart';

@module
abstract class ${className}Module {}
''';
