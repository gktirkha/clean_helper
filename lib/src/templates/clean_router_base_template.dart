/// `<prefix>Base`: the interface every feature router implements, and
/// `<prefix>Priority`, the bands a router's [priority] is picked from.
String cleanRouterBaseTemplate(String prefix) =>
    '''
import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

abstract interface class ${prefix}Base {
  List<RouteBase> get routes;
  List<Stream<dynamic>> get refreshStreams;
  FutureOr<String?> redirect(BuildContext context, GoRouterState state);

  /// Lower runs first (routes and redirects). Pick a `${prefix}Priority`
  /// band, adding a small offset to order routers inside one band.
  int get priority;
}

/// Priority bands for [${prefix}Base.priority]; lower runs first.
abstract final class ${prefix}Priority {
  /// Gates every other route depends on: auth, onboarding, maintenance.
  static const gate = 0;

  /// The app's shell and home.
  static const shell = 100;

  /// Ordinary features: the default.
  static const feature = 200;

  /// Catch-all and not-found routes.
  static const fallback = 900;
}
''';
