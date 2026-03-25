import 'dart:io';

import 'generate_feature_bloc.dart';
import 'generate_feature_module.dart';
import 'generate_feature_navigation.dart';
import 'generate_feature_navigation_impl.dart';
import 'generate_feature_page.dart';
import 'generate_feature_router.dart';
import 'generate_feature_routes.dart';

void createFeatureStructure(String basePath, String featureName) {
  final directories = [
    '$basePath/data/constants',
    '$basePath/data/datasources',
    '$basePath/data/models/requests',
    '$basePath/data/models/response',
    '$basePath/data/repositories',
    '$basePath/di',
    '$basePath/domain/entities',
    '$basePath/domain/repositories',
    '$basePath/domain/use_cases',
    '$basePath/presentation/bloc/$featureName',
    '$basePath/presentation/pages',
    '$basePath/presentation/widgets',
    '$basePath/router',
    'lib/app/navigations',
  ];

  for (final dir in directories) {
    Directory(dir).createSync(recursive: true);
  }

  generateFeatureRoutes(featureName, basePath);
  generateFeatureNavigation(featureName, basePath);
  generateFeatureNavigationImpl(featureName);
  generateFeaturePage(featureName, basePath);
  generateFeatureRouter(featureName, basePath);
  generateFeatureBloc(featureName, basePath);
  generateFeatureModule(featureName, basePath);
}
