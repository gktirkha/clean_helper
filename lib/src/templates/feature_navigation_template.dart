String featureNavigationTemplate(String className) =>
    '''
import 'package:material_ui/material_ui.dart';

abstract class ${className}Navigation {
  void goTo$className([BuildContext? context]);
}
''';
