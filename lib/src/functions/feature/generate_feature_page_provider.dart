import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/feature_page_provider_template.dart';

/// [bloc] is the bloc the page provider provides; null provides none.
void generateFeaturePageProvider(
  String feature,
  String basePath, {
  String? bloc,
}) {
  final className = pascalCase(feature);
  writeFile(
    '$basePath/presentation/page_providers/${feature}_page_provider.dart',
    featurePageProviderTemplate(feature, className, bloc: bloc),
  );
}
