import 'dart:io';

import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/feature_api_paths_template.dart';

void generateApiPaths(String dataDir, String feature, String repoName) {
  final className = pascalCase(feature);
  final path = '$dataDir/constants/${feature}_api_paths.dart';

  writeFile(path, featureApiPathsTemplate(className, repoName, feature));
  stdout.writeln('  📄 $path');
}
