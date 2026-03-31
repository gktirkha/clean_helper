import 'generate_feature_bloc.dart';
import 'generate_feature_module.dart';
import 'generate_feature_navigation.dart';
import 'generate_feature_navigation_impl.dart';
import 'generate_feature_page.dart';
import 'generate_feature_router.dart';
import 'generate_feature_routes.dart';

void createFeatureStructure(
  String basePath,
  String featureName, {
  bool withDi = false,
}) {
  generateFeatureRoutes(featureName, basePath);
  generateFeatureNavigation(featureName, basePath);
  generateFeatureNavigationImpl(featureName);
  generateFeaturePage(featureName, basePath);
  generateFeatureRouter(featureName, basePath);
  generateFeatureBloc(featureName, basePath);
  if (withDi) generateFeatureModule(featureName, basePath);
}
