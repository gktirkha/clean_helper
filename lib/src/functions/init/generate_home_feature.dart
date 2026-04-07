import 'dart:io';

import '../feature/generate_feature_bloc.dart';
import '../feature/generate_feature_module.dart';
import '../feature/generate_feature_navigation.dart';
import '../feature/generate_feature_navigation_impl.dart';
import '../feature/generate_feature_page.dart';
import '../feature/generate_feature_routes.dart';
import '../feature/generate_feature_router.dart';

void generateHomeFeature(String packageName, {bool withDi = false}) {
  const feature = 'home';
  const basePath = 'lib/features/home';

  generateFeatureRoutes(feature, basePath);
  generateFeatureNavigation(feature, basePath);
  generateFeatureNavigationImpl(feature);
  generateFeatureRouter(feature, basePath);
  generateFeaturePage(feature, basePath);
  generateFeatureBloc(feature, basePath);

  if (withDi) {
    generateFeatureModule(feature, basePath);
  }

  stdout.writeln('🏠 Home feature generated');
  stdout.writeln();
}
