import 'dart:io';

import '../shared/kebab_case.dart';
import '../shared/pascal_case.dart';
import '../shared/write_file.dart';

void generateApiPaths(String dataDir, String feature, String repoName) {
  final className = pascalCase(feature);
  final path = '$dataDir/constants/${feature}_api_paths.dart';

  writeFile(path, '''
sealed class ${className}ApiPaths {
  static const String $repoName = '/api/${kebabCase(feature)}/';
}
''');
  stdout.writeln('  📄 $path');
}
