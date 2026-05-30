String featureRouterTemplate(String feature, String className) =>
    '''
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import 'package:clean_router/clean_router.dart';

import '../presentation/page_providers/${feature}_page_provider.dart';
import '${feature}_routes.dart';

@lazySingleton
class ${className}Router implements CleanRouterBase {
  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: ${className}Routes.$feature,
      builder: (context, state) => const ${className}PageProvider(),
    ),
  ];

  @override
  List<Stream<dynamic>> get refreshStreams => [];

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) => null;

  // TODO: set intended priority — lower number = higher precedence in router list
  @override
  int get priority => 10;
}
''';
