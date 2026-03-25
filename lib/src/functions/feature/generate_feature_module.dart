import 'dart:io';

import '../shared/pascal_case.dart';

void generateFeatureModule(String feature, String basePath) {
  final className = pascalCase(feature);

  File('$basePath/di/${feature}_module.dart').writeAsStringSync('''
import 'package:injectable/injectable.dart';

@module
abstract class ${className}Module {}
''');
}
