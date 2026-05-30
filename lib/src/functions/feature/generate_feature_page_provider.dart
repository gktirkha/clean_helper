import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/feature_page_provider_template.dart';

void generateFeaturePageProvider(String feature, String basePath) {
  final className = pascalCase(feature);
  writeFile(
    '$basePath/presentation/page_providers/${feature}_page_provider.dart',
    featurePageProviderTemplate(feature, className),
  );
}
