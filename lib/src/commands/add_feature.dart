import 'dart:io';

void addFeature(List<String> args) {
  if (!File('pubspec.yaml').existsSync()) {
    stderr.writeln(
      '❌ pubspec.yaml not found. Run this tool from the Flutter project root.',
    );
    exit(1);
  }

  if (args.isEmpty) {
    stdout.write('❌ Please provide a feature name');
    stdout.write('Usage: dart run tools/generate_feature.dart <feature_name>');
    return;
  }

  final featureName = args.first.toLowerCase();
  final basePath = 'lib/features/$featureName';

  stdout.write('🚀 Generating feature: $featureName');

  _createStructure(basePath, featureName);

  stdout.write('✅ Feature "$featureName" generated successfully!');
  stdout.write('\n');
}

void _createStructure(String basePath, String featureName) {
  final directories = [
    '$basePath/data/constants',
    '$basePath/data/datasources',
    '$basePath/data/models/requests',
    '$basePath/data/models/response',
    '$basePath/data/repositories',
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

  _generateRoutes(featureName, basePath);
  _generateNavigation(featureName, basePath);
  _generateNavigationImpl(featureName);
  _generatePage(featureName, basePath);
  _generateRouter(featureName, basePath);
  _generateBloc(featureName, basePath);
}

void _generateRoutes(String feature, String basePath) {
  final className = _pascalCase(feature);

  final content =
      '''
sealed class ${className}Routes {
  static const String $feature = '/${_kebabCase(feature)}';
}
''';

  File('$basePath/router/${feature}_routes.dart').writeAsStringSync(content);
}

void _generateNavigation(String feature, String basePath) {
  final className = _pascalCase(feature);

  final content =
      '''
import 'package:flutter/material.dart';

abstract class ${className}Navigation {
  void goTo$className(BuildContext context);
}
''';

  File(
    '$basePath/router/${feature}_navigation.dart',
  ).writeAsStringSync(content);
}

void _generateNavigationImpl(String feature) {
  final className = _pascalCase(feature);

  final content =
      '''
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/$feature/router/${feature}_navigation.dart';
import '../../features/$feature/router/${feature}_routes.dart';

@LazySingleton(as: ${className}Navigation)
class ${className}NavigationImpl implements ${className}Navigation {
  @override
  void goTo$className(BuildContext context) {
    context.go(${className}Routes.$feature);
  }
}
''';

  File(
    'lib/app/navigations/${feature}_navigation_impl.dart',
  ).writeAsStringSync(content);
}

void _generatePage(String feature, String basePath) {
  final className = _pascalCase(feature);

  final content =
      '''
import 'package:flutter/material.dart';

import '../../router/${feature}_navigation.dart';

class ${className}Page extends StatelessWidget {
  const ${className}Page({super.key, required this.navigation});

  final ${className}Navigation navigation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('$className')),
      body: const Center(child: Text('$className Page')),
    );
  }
}
''';

  File(
    '$basePath/presentation/pages/${feature}_page.dart',
  ).writeAsStringSync(content);
}

void _generateRouter(String feature, String basePath) {
  final className = _pascalCase(feature);

  final content =
      '''
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/router/router_base.dart';
import '../presentation/pages/${feature}_page.dart';
import '${feature}_navigation.dart';
import '${feature}_routes.dart';

@lazySingleton
class ${className}Router implements RouterBase {
  ${className}Router({required ${className}Navigation ${_camelCase(feature)}Navigation})
    : _${_camelCase(feature)}Navigation = ${_camelCase(feature)}Navigation;

  final ${className}Navigation _${_camelCase(feature)}Navigation;

  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: ${className}Routes.$feature,
      builder: (context, state) => ${className}Page(navigation: _${_camelCase(feature)}Navigation),
    ),
  ];

  @override
  List<Stream<dynamic>> get refreshStreams => [];

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) => null;

  @override
  int get priority => 10;
}
''';

  File('$basePath/router/${feature}_router.dart').writeAsStringSync(content);
}

void _generateBloc(String feature, String basePath) {
  final className = _pascalCase(feature);

  final blocContent =
      '''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part '${feature}_bloc.freezed.dart';
part '${feature}_event.dart';
part '${feature}_state.dart';

@lazySingleton
class ${className}Bloc extends Bloc<${className}Event, ${className}State> {
  ${className}Bloc() : super(const .initial()) {
    on<${className}Event>((event, emit) {});
  }
}
''';

  final eventContent =
      '''
part of '${feature}_bloc.dart';

@freezed
abstract class ${className}Event with _\$${className}Event {
  const factory ${className}Event.started() = _Started;
}
''';

  final stateContent =
      '''
part of '${feature}_bloc.dart';

@freezed
abstract class ${className}State with _\$${className}State {
  const factory ${className}State.initial() = _Initial;
}
''';

  final blocPath = '$basePath/presentation/bloc/$feature';

  File('$blocPath/${feature}_bloc.dart').writeAsStringSync(blocContent);
  File('$blocPath/${feature}_event.dart').writeAsStringSync(eventContent);
  File('$blocPath/${feature}_state.dart').writeAsStringSync(stateContent);
}

String _pascalCase(String input) {
  return input
      .split('_')
      .map((e) => e[0].toUpperCase() + e.substring(1))
      .join();
}

String _camelCase(String input) {
  final pascal = _pascalCase(input);
  return pascal[0].toLowerCase() + pascal.substring(1);
}

String _kebabCase(String input) {
  return input.replaceAll('_', '-');
}
