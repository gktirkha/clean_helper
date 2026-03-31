import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/feature_navigation_impl_template.dart';

void generateFeatureNavigationImpl(String feature) {
  final className = pascalCase(feature);
  writeFile(
    'lib/app/navigations/${feature}_navigation_impl.dart',
    featureNavigationImplTemplate(feature, className),
  );
}
