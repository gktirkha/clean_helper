import '../shared/abort.dart';
import '../shared/package_configs.dart';
import '../shared/pascal_case.dart';
import '../shared/read_package_name.dart';
import 'generate_feature_bloc.dart';
import 'generate_feature_module.dart';
import 'generate_feature_navigation.dart';
import 'generate_feature_navigation_impl.dart';
import 'generate_feature_page.dart';
import 'generate_feature_router.dart';
import 'generate_feature_routes.dart';
import 'generate_feature_page_provider.dart';

void createFeatureStructure(
  String basePath,
  String featureName,
  String utilsImport,
  PackageConfig router, {
  bool withDi = false,
}) {
  // The app's router is <AppPascal>Router; a feature with the app's name would
  // generate a second class with that name.
  final app = readPackageName();
  if (pascalCase(featureName) == pascalCase(app)) {
    abort(
      'A feature can\'t be named after the app ("$app"): both would '
      'generate ${pascalCase(app)}Router.',
    );
  }

  generateFeatureRoutes(featureName, basePath);
  generateFeatureNavigation(featureName, basePath);
  generateFeatureNavigationImpl(featureName, utilsImport);
  generateFeaturePage(featureName, basePath);
  generateFeaturePageProvider(featureName, basePath);
  generateFeatureRouter(featureName, basePath, router);
  generateFeatureBloc(featureName, basePath);
  if (withDi) generateFeatureModule(featureName, basePath);
}
