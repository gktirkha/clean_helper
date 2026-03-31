import '../shared/pascal_case.dart';
import '../shared/write_file.dart';

void generateFeatureModule(String feature, String basePath) {
  final className = pascalCase(feature);

  writeFile('$basePath/di/${feature}_module.dart', '''
import 'package:injectable/injectable.dart';

@module
abstract class ${className}Module {}
''');
}
