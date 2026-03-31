import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/feature_navigation_template.dart';

void generateFeatureNavigation(String feature, String basePath) {
  final className = pascalCase(feature);
  writeFile(
    '$basePath/router/${feature}_navigation.dart',
    featureNavigationTemplate(className),
  );
}
