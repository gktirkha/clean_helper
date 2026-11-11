import '../../templates/feature_navigation_template.dart';
import '../shared/pascal_case.dart';
import '../shared/write_file.dart';

void generateFeatureNavigation(String feature, String basePath) {
  writeFile(
    '$basePath/router/${feature}_navigation.dart',
    featureNavigationTemplate(pascalCase(feature)),
  );
}
