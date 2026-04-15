import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/feature_screen_template.dart';

void generateFeatureScreen(String feature, String basePath) {
  final className = pascalCase(feature);
  writeFile(
    '$basePath/presentation/screens/${feature}_screen.dart',
    featureScreenTemplate(feature, className),
  );
}
