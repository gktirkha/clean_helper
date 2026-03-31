String appGoRouterTemplate(String pkg) => '''
import 'dart:async';

import 'package:clean_router/clean_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../di/di_container.dart';
import '../../features/home/router/home_routes.dart';

part 'app_go_router_redirect.dart';

class AppGoRouter {
  AppGoRouter({required this.routers});

  final List<CleanRouterBase> routers;

  late final router = GoRouter(
    navigatorKey: diContainer<GlobalKey<NavigatorState>>(),
    debugLogDiagnostics: true,
    initialLocation: HomeRoutes.home,
    routes: [...routers.expand((r) => r.routes)],
    redirect: (context, state) => _handleRedirect(context, state, routers),
    refreshListenable: CleanRouterRefresh(
      routers.expand((r) => r.refreshStreams).toList(),
    ),
  );
}
''';
