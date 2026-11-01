/// [optionalContext] is false for projects whose utils package has no
/// `ContextUtils` (initialised before 1.6.0): the navigation impl can't fall
/// back to the root context, so callers must pass one.
String featureNavigationTemplate(
  String className, {
  bool optionalContext = true,
}) =>
    '''
import 'package:flutter/material.dart';

abstract class ${className}Navigation {
  void goTo$className(${optionalContext ? '[BuildContext? context]' : 'BuildContext context'});
}
''';
