/// The feature's outgoing navigation. `goBack` is the generated sample; add a
/// method here for every screen the feature opens (`goToCart`), so the
/// feature never imports another feature.
String featureNavigationTemplate(String className) =>
    '''
import 'package:material_ui/material_ui.dart';

/// Where $className can navigate to. To open another feature, add a method
/// here (e.g. `goToCart`) and implement it in the app's navigation impl;
/// never import the other feature.
abstract class ${className}Navigation {
  void goBack([BuildContext? context]);
}
''';
