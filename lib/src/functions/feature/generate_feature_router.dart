import '../../templates/feature_router_template.dart';
import '../shared/package_configs.dart';
import '../shared/pascal_case.dart';
import '../shared/write_file.dart';

/// [router] is the router package: its import and `<RouterPascal>Base`.
void generateFeatureRouter(
  String feature,
  String basePath,
  PackageConfig router,
) {
  writeFile(
    '$basePath/router/${feature}_router.dart',
    featureRouterTemplate(
      feature,
      pascalCase(feature),
      router.import,
      pascalCase(router.name),
    ),
  );
}
