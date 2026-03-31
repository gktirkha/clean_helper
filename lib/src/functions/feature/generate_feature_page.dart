import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/feature_page_template.dart';

void generateFeaturePage(String feature, String basePath) {
  final className = pascalCase(feature);
  writeFile(
    '$basePath/presentation/pages/${feature}_page.dart',
    featurePageTemplate(feature, className),
  );
}
