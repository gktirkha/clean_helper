import '../../templates/feature_navigation_impl_template.dart';
import '../shared/pascal_case.dart';
import '../shared/write_file.dart';

void generateFeatureNavigationImpl(String feature, String utilsImport) {
  writeFile(
    'lib/app/navigation/${feature}_navigation_impl.dart',
    featureNavigationImplTemplate(feature, pascalCase(feature), utilsImport),
  );
}
