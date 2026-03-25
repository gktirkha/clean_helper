import 'dart:io';

import '../shared/camel_case.dart';
import '../shared/pascal_case.dart';

void generateFeatureRouter(String feature, String basePath) {
  final className = pascalCase(feature);
  final camel = camelCase(feature);
  final content =
      '''
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../../core/router/router_base.dart';
import '../presentation/pages/${feature}_page.dart';
import '${feature}_navigation.dart';
import '${feature}_routes.dart';

@lazySingleton
class ${className}Router implements RouterBase {
  ${className}Router({required ${className}Navigation ${camel}Navigation})
    : _${camel}Navigation = ${camel}Navigation;

  final ${className}Navigation _${camel}Navigation;

  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: ${className}Routes.$feature,
      builder: (context, state) => ${className}Page(navigation: _${camel}Navigation),
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
  File('$basePath/router/${feature}_router.dart').writeAsStringSync(content);
}
