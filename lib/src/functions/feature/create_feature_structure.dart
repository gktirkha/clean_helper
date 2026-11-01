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
  String utilsImport, {
  bool withDi = false,
  bool contextUtils = true,
}) {
  generateFeatureRoutes(featureName, basePath);
  generateFeatureNavigation(
    featureName,
    basePath,
    optionalContext: contextUtils,
  );
  generateFeatureNavigationImpl(
    featureName,
    utilsImport,
    contextUtils: contextUtils,
  );
  generateFeaturePage(featureName, basePath);
  generateFeaturePageProvider(featureName, basePath);
  generateFeatureRouter(featureName, basePath);
  generateFeatureBloc(featureName, basePath);
  if (withDi) generateFeatureModule(featureName, basePath);
}
