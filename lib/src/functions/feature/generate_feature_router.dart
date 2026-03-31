import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/feature_router_template.dart';

void generateFeatureRouter(String feature, String basePath) {
  final className = pascalCase(feature);
  writeFile(
    '$basePath/router/${feature}_router.dart',
    featureRouterTemplate(feature, className),
  );
}
