import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/feature_module_template.dart';

void generateFeatureModule(String feature, String basePath) {
  final className = pascalCase(feature);

  writeFile(
    '$basePath/di/${feature}_module.dart',
    featureModuleTemplate(className, feature),
  );
}
