import 'dart:io';

import '../../templates/feature_api_paths_template.dart';
import '../shared/camel_case.dart';
import '../shared/kebab_case.dart';
import '../shared/pascal_case.dart';
import '../shared/write_file.dart';

/// Writes `<dataDir>/constants/<feature>_api_paths.dart` with a constant for
/// [repoName], or adds the constant to the existing class when another repo
/// in the feature created the file first.
void generateApiPaths(String dataDir, String feature, String repoName) {
  final path = '$dataDir/constants/${feature}_api_paths.dart';
  final file = File(path);

  if (!file.existsSync()) {
    writeFile(
      path,
      featureApiPathsTemplate(pascalCase(feature), repoName, feature),
    );
    stdout.writeln('  📄 $path');
    return;
  }

  final content = file.readAsStringSync();
  final constant = camelCase(repoName);
  if (RegExp('static const String $constant\\b').hasMatch(content)) {
    stdout.writeln('  ⏭  $constant already in $path');
    return;
  }

  final lastBrace = content.lastIndexOf('}');
  overwriteFile(
    path,
    '${content.substring(0, lastBrace)}'
    "  static const String $constant = '/api/${kebabCase(feature)}/';\n"
    '${content.substring(lastBrace)}',
  );
}
