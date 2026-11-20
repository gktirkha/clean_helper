/// `<prefix>Base`: the interface every feature router implements.
String cleanRouterBaseTemplate(String prefix) =>
    '''
import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

abstract interface class ${prefix}Base {
  List<RouteBase> get routes;
  List<Stream<dynamic>> get refreshStreams;
  FutureOr<String?> redirect(BuildContext context, GoRouterState state);
  int get priority;
}
''';
