import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/feature_routes_template.dart';

void generateFeatureRoutes(String feature, String basePath) {
  final className = pascalCase(feature);
  writeFile(
    '$basePath/router/${feature}_routes.dart',
    featureRoutesTemplate(feature, className),
  );
}
