import 'dart:io';

// ─────────────────────────────────────────────────────────────
// Entry point
// ─────────────────────────────────────────────────────────────

void main() {
  if (!File('pubspec.yaml').existsSync()) {
    _abort(
      'pubspec.yaml not found. Run this tool from the Flutter project root.',
    );
  }

  final packageName = _readPackageName();

  _log('Initializing architecture for: $packageName');
  _log('');

  _createDirectories();
  _generateLocalizationFiles();
  _generateFlutterGenFiles();
  _generateCoreFiles(packageName);
  _generateNetworkFiles();
  _generateHomeFeature(packageName);
  _installDependencies();
  _addChuckerDependency();
  _addFlutterAssetsToPubSpec();
  _runSlang();
  _runBuildRunner();
  _runDartFormat();

  _log('');
  _log('✅ Done! Project is ready.');
  _log('');
  _log('Next steps:');
  _log('  • Add a feature:     dart run tools/generate_feature.dart <name>');
  _log('  • Add a route:       /new-route <name>  (Claude Code skill)');
  _log('  • Register routers:  lib/app/router/router_module.dart');
}

// ─────────────────────────────────────────────────────────────
// Directories
// ─────────────────────────────────────────────────────────────

void _createDirectories() {
  final dirs = [
    // core
    'lib/app/router',
    'lib/app/navigations',
    'lib/core/di',
    'lib/core/router',
    'lib/core/generated/locales',
    'lib/core/generated/flutter_gen',
    'assets/locales',
    'assets/colors',
    // network
    'lib/core/network/constants',
    'lib/core/network/di',
    'lib/core/network/interceptors',
    'lib/core/network/models',
    'lib/core/data/models',
    'lib/core/domain/entities',
    'lib/core/services',
    // home feature
    'lib/features/home/data/constants',
    'lib/features/home/data/datasources',
    'lib/features/home/data/models/requests',
    'lib/features/home/data/models/response',
    'lib/features/home/data/repositories',
    'lib/features/home/domain/entities',
    'lib/features/home/domain/repositories',
    'lib/features/home/domain/use_cases',
    'lib/features/home/presentation/bloc/home',
    'lib/features/home/presentation/pages',
    'lib/features/home/presentation/widgets',
    'lib/features/home/router',
  ];

  for (final dir in dirs) {
    Directory(dir).createSync(recursive: true);
  }
  _log('📁 Directories created');
}

// ─────────────────────────────────────────────────────────────
// FlutterGen files
// ─────────────────────────────────────────────────────────────

void _generateFlutterGenFiles() {
  _write('build.yaml', '''
targets:
  \$default:
    builders:
      flutter_gen_runner:
        options:
          output: lib/core/generated/flutter_gen
          integrations:
            flutter_svg: true

          assets:
            outputs:
              directory_path_enabled: true

          colors:
            inputs:
              - assets/colors/colors.xml
''');

  _write('assets/colors/colors.xml', '''
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="black" type="material material-accent">#000000</color>
</resources>
''');

  _log('🎨 FlutterGen files generated');
}

// ─────────────────────────────────────────────────────────────
// Patch pubspec.yaml flutter assets
// ─────────────────────────────────────────────────────────────

void _addFlutterAssetsToPubSpec() {
  final pubspec = File('pubspec.yaml');
  final content = pubspec.readAsStringSync();

  if (content.contains('assets/colors') && content.contains('assets/locales')) {
    _log('  ⏭  Skipped (exists): flutter assets in pubspec.yaml');
    return;
  }

  // Find the flutter: section and inject assets block after it
  final updated = content.replaceFirst(
    RegExp(r'(^flutter:\s*$)', multiLine: true),
    '''flutter:
  assets:
    - assets/colors/
    - assets/locales/
''',
  );

  pubspec.writeAsStringSync(updated);
  _log('📋 Flutter assets added to pubspec.yaml');
}

// ─────────────────────────────────────────────────────────────
// Localization files
// ─────────────────────────────────────────────────────────────

void _generateLocalizationFiles() {
  _write('slang.yaml', '''
base_locale: en
fallback_strategy: base_locale
input_directory: assets/locales
input_file_pattern: .locale.json
output_directory: lib/core/generated/locales
output_file_name: locales.g.dart
translate_var: locales
''');

  _write('assets/locales/en.locale.json', '''
{
  "general": {
    "languageName": "English"
  }
}
''');

  _log('🌐 Localization files generated');
}

// ─────────────────────────────────────────────────────────────
// Core files
// ─────────────────────────────────────────────────────────────

void _generateCoreFiles(String packageName) {
  _overwrite('analysis_options.yaml', _analysisOptionsDart());
  _write('lib/main.dart', _mainDart());
  _write('lib/app/bootstrap.dart', _bootstrapDart(packageName));
  _write('lib/app/main_app.dart', _mainAppDart(packageName));
  _write('lib/app/router/app_go_router.dart', _appGoRouterDart(packageName));
  _write('lib/app/router/router_module.dart', _routerModuleDart(packageName));
  _write('lib/core/di/di_container.dart', _diContainerDart());
  _write('lib/core/di/core_module.dart', _coreModuleDart());
  _write('lib/core/di/di_initializer.dart', _diInitializerDart());
  _write('lib/core/router/router_base.dart', _routerBaseDart());
  _write('lib/core/router/router_refresh.dart', _routerRefreshDart());
  _write('lib/core/di/di_keys.dart', _diKeysDart());
  _log('⚙️  Core files generated');
}

// ─────────────────────────────────────────────────────────────
// Network files
// ─────────────────────────────────────────────────────────────

void _generateNetworkFiles() {
  _write('lib/core/network/constants/api_paths.dart', '''
sealed class ApiPaths {
  static const String baseUrl = 'https://your-api.com/api/';
}
''');

  _write('lib/core/domain/entities/error_entity.dart', '''
abstract class ErrorEntity {
  List<String> get errors;
}
''');

  _write('lib/core/data/models/error_model.dart', '''
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/error_entity.dart';

part 'error_model.freezed.dart';
part 'error_model.g.dart';

@freezed
sealed class ErrorModel with _\$ErrorModel implements ErrorEntity {
  const factory ErrorModel({
    @Default([]) @JsonKey(name: 'errors') List<String> errors,
  }) = _ErrorModel;

  factory ErrorModel.fromJson(Map<String, dynamic> json) =>
      _\$ErrorModelFromJson(json);
}
''');

  _write('lib/core/network/interceptors/error_interceptor.dart', '''
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/error_model.dart';

@lazySingleton
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    final statusCode = response?.statusCode;

    if (statusCode == null || statusCode == 401 || response == null) {
      handler.next(err);
      return;
    }

    final data = response.data;

    final isValidErrorResponse =
        data is Map<String, dynamic> &&
        data.containsKey('errors') &&
        data['errors'] is List;

    if (!isValidErrorResponse) {
      handler.next(err);
      return;
    }

    final errorList = ErrorModel.fromJson(data);

    if (errorList.errors.isEmpty) {
      handler.next(err);
      return;
    }

    handler.next(
      err.copyWith(
        response: Response(
          requestOptions: response.requestOptions,
          data: errorList,
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          headers: response.headers,
          extra: response.extra,
          isRedirect: response.isRedirect,
          redirects: response.redirects,
        ),
      ),
    );
  }
}
''');

  _write('lib/core/network/di/network_module.dart', '''
import 'dart:io';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_paths.dart';
import '../interceptors/error_interceptor.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  BaseOptions baseOptions(PackageInfo packageInfo) => BaseOptions(
    baseUrl: ApiPaths.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(minutes: 5),
    headers: {
      'User-Agent':
          '\${packageInfo.appName}-\${Platform.operatingSystem}/\${packageInfo.version}+\${packageInfo.buildNumber}',
    },
  );

  @lazySingleton
  Dio dio(
    BaseOptions baseOptions,
    ErrorInterceptor errorInterceptor,
  ) => Dio(baseOptions)
    ..interceptors.addAll([
      errorInterceptor,
      ChuckerDioInterceptor(),
      PrettyDioLogger(),
    ]);
}
''');

  _log('🌐 Network module generated');
}

// ─────────────────────────────────────────────────────────────
// Home feature
// ─────────────────────────────────────────────────────────────

void _generateHomeFeature(String packageName) {
  const basePath = 'lib/features/home';

  _write('$basePath/router/home_routes.dart', '''
sealed class HomeRoutes {
  static const String home = '/home';
}
''');

  _write('$basePath/router/home_navigation.dart', '''
import 'package:flutter/material.dart';

abstract class HomeNavigation {
  void goToHome(BuildContext context);
}
''');

  _write('lib/app/navigations/home_navigation_impl.dart', '''
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/home/router/home_navigation.dart';
import '../../features/home/router/home_routes.dart';

@Singleton(as: HomeNavigation)
class HomeNavigationImpl implements HomeNavigation {
  @override
  void goToHome(BuildContext context) {
    context.go(HomeRoutes.home);
  }
}
''');

  _write('$basePath/router/home_router.dart', '''
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/router/router_base.dart';
import '../presentation/pages/home_page.dart';
import 'home_navigation.dart';
import 'home_routes.dart';

@lazySingleton
class HomeRouter implements RouterBase {
  HomeRouter({required HomeNavigation homeNavigation})
    : _homeNavigation = homeNavigation;

  final HomeNavigation _homeNavigation;

  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: HomeRoutes.home,
      builder: (context, state) => HomePage(navigation: _homeNavigation),
    ),
  ];

  @override
  List<Stream<dynamic>> get refreshStreams => [];

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) => null;

  @override
  int get priority => 10;
}
''');

  _write('$basePath/presentation/pages/home_page.dart', '''
import 'package:flutter/material.dart';

import '../../router/home_navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.navigation});

  final HomeNavigation navigation;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Home')),
    );
  }
}
''');

  _write('$basePath/presentation/bloc/home/home_bloc.dart', '''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

@lazySingleton
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState.initial()) {
    on<HomeEvent>((event, emit) {});
  }
}
''');

  _write('$basePath/presentation/bloc/home/home_event.dart', '''
part of 'home_bloc.dart';

@freezed
abstract class HomeEvent with _\$HomeEvent {
  const factory HomeEvent.started() = _Started;
}
''');

  _write('$basePath/presentation/bloc/home/home_state.dart', '''
part of 'home_bloc.dart';

@freezed
abstract class HomeState with _\$HomeState {
  const factory HomeState.initial() = _Initial;
}
''');

  _log('🏠 Home feature generated');
}

// ─────────────────────────────────────────────────────────────
// Dependencies
// ─────────────────────────────────────────────────────────────

void _installDependencies() {
  _log('📦 Installing dependencies...');

  final deps = [
    'flutter_bloc',
    'go_router',
    'get_it',
    'injectable',
    'freezed_annotation',
    'fpdart',
    'slang',
    'slang_flutter',
    'dio',
    'retrofit',
    'json_annotation',
    'package_info_plus',
    'flutter_svg',
    'pretty_dio_logger',
  ];

  final devDeps = [
    'build_runner',
    'injectable_generator',
    'freezed',
    'retrofit_generator',
    'json_serializable',
    'flutter_gen_runner',
  ];

  // flutter_localizations is an SDK package — needs flutter pub add
  _run(['flutter', 'pub', 'add', 'flutter_localizations', '--sdk=flutter']);
  _run(['dart', 'pub', 'add', ...deps]);
  _run(['dart', 'pub', 'add', '--dev', ...devDeps]);

  _log('📦 Dependencies installed');
}

// ─────────────────────────────────────────────────────────────
// Chucker (git dependency — injected directly into pubspec.yaml)
// ─────────────────────────────────────────────────────────────

void _addChuckerDependency() {
  _run([
    'flutter',
    'pub',
    'add',
    'chucker_flutter',
    '--git-url=https://github.com/gktirkha/chucker-flutter.git',
  ]);
  _log('🔍 Chucker dependency added');
}

// ─────────────────────────────────────────────────────────────
// Slang
// ─────────────────────────────────────────────────────────────

void _runSlang() {
  _log('🌐 Running slang...');
  _run(['dart', 'run', 'slang']);
  _log('🌐 Slang generation complete');
}

// ─────────────────────────────────────────────────────────────
// Dart format
// ─────────────────────────────────────────────────────────────

void _runDartFormat() {
  _log('🎨 Formatting code...');
  _run(['dart', 'format', '.']);
  _log('🎨 Formatting complete');
}

// ─────────────────────────────────────────────────────────────
// Build runner
// ─────────────────────────────────────────────────────────────

void _runBuildRunner() {
  _log('🔨 Running build_runner...');
  _run([
    'dart',
    'run',
    'build_runner',
    'build',
    '--delete-conflicting-outputs',
  ]);
  _log('🔨 Code generation complete');
}

// ─────────────────────────────────────────────────────────────
// File content generators
// ─────────────────────────────────────────────────────────────

String _analysisOptionsDart() => '''
include: package:flutter_lints/flutter.yaml
analyzer:
  errors:
    constant_identifier_names: ignore
    invalid_annotation_target: ignore
    unnecessary_constructor_name: ignore

linter:
  rules:
    - avoid_redundant_argument_values
    - exhaustive_cases
    - sort_constructors_first
    - prefer_relative_imports
    - require_trailing_commas
    - sort_pub_dependencies
    - prefer_single_quotes
    - prefer_const_constructors
''';

String _mainDart() => '''
import 'app/bootstrap.dart';

void main() {
  bootstrap();
}
''';

String _bootstrapDart(String pkg) => '''
import 'package:flutter/material.dart';

import '../core/di/di_container.dart';
import '../core/di/di_initializer.dart';
import '../core/generated/locales/locales.g.dart';
import 'main_app.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  await diInitializer(diContainer);
  runApp(const MainApp());
}
''';

String _mainAppDart(String pkg) => '''
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/di/di_container.dart';
import '../core/generated/locales/locales.g.dart';
import 'router/app_go_router.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(child: const _AppView());
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: diContainer<GlobalKey<ScaffoldMessengerState>>(),
      locale: TranslationProvider.of(context).flutterLocale,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: AppLocaleUtils.supportedLocales,
      routerConfig: diContainer<AppGoRouter>().router,
    );
  }
}
''';

String _appGoRouterDart(String pkg) => '''
import 'dart:async';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/di_container.dart';
import '../../core/router/router_base.dart';
import '../../core/router/router_refresh.dart';
import '../../features/home/router/home_routes.dart';

class AppGoRouter {
  AppGoRouter({required this.routers});

  final List<RouterBase> routers;

  late final router = GoRouter(
    navigatorKey: diContainer<GlobalKey<NavigatorState>>(),
    debugLogDiagnostics: true,
    initialLocation: HomeRoutes.home,
    routes: [...routers.expand((r) => r.routes)],
    redirect: _handleRedirect,
    refreshListenable: GoRouterRefreshStream(
      routers.expand((r) => r.refreshStreams).toList(),
    ),
    observers: [ChuckerFlutter.navigatorObserver],
  );

  FutureOr<String?> _handleRedirect(
    BuildContext context,
    GoRouterState state,
  ) {
    for (final router in routers) {
      final result = router.redirect(context, state);
      if (result != null) return result;
    }
    return null;
  }
}
''';

String _routerModuleDart(String pkg) => '''
import 'package:injectable/injectable.dart';

import '../../features/home/router/home_router.dart';
import 'app_go_router.dart';

@module
abstract class RouterModule {
  @lazySingleton
  AppGoRouter appGoRouter(HomeRouter homeRouter) => AppGoRouter(
    routers: [homeRouter]..sort((a, b) => a.priority.compareTo(b.priority)),
  );
}
''';

String _diContainerDart() => '''
import 'package:get_it/get_it.dart';

final GetIt diContainer = GetIt.instance;
''';

String _coreModuleDart() => '''
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

@module
abstract class CoreModule {
  @lazySingleton
  GlobalKey<NavigatorState> get navigationKey => GlobalKey<NavigatorState>();

  @lazySingleton
  GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey =>
      GlobalKey<ScaffoldMessengerState>();

  @preResolve
  @lazySingleton
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();
}
''';

String _diInitializerDart() => '''
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di_initializer.config.dart';

@InjectableInit(preferRelativeImports: true)
Future<void> diInitializer(GetIt instance) async {
  await instance.init();
}
''';

String _routerBaseDart() => '''
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract interface class RouterBase {
  List<RouteBase> get routes;
  List<Stream<dynamic>> get refreshStreams;
  FutureOr<String?> redirect(BuildContext context, GoRouterState state);
  int get priority;
}
''';

String _diKeysDart() => '''
sealed class DIKeys {
  static const String noAuthDio = 'noAuthDio';
}
''';

String _routerRefreshDart() => '''
import 'dart:async';

import 'package:flutter/foundation.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(List<Stream<dynamic>> streams) {
    _subscription = streams
        .map((stream) => stream.listen((_) => notifyListeners()))
        .toList();
  }

  late final List<StreamSubscription<dynamic>> _subscription;

  @override
  void dispose() {
    for (final sub in _subscription) {
      sub.cancel();
    }
    super.dispose();
  }
}
''';

// ─────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────

String _readPackageName() {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    _abort('pubspec.yaml not found. Run this tool from the project root.');
  }
  final lines = pubspec.readAsLinesSync();
  for (final line in lines) {
    if (line.startsWith('name:')) {
      return line.split(':').last.trim();
    }
  }
  _abort('Could not read package name from pubspec.yaml.');
}

void _run(List<String> cmd) {
  final result = Process.runSync(cmd.first, cmd.sublist(1), runInShell: true);
  if (result.exitCode != 0) {
    stderr.writeln('⚠️  Command failed: ${cmd.join(' ')}');
    stderr.writeln(result.stderr);
  }
}

void _write(String path, String content) {
  final file = File(path);
  if (file.existsSync()) {
    _log('  ⏭  Skipped (exists): $path');
    return;
  }
  file.writeAsStringSync(content);
}

void _overwrite(String path, String content) {
  File(path).writeAsStringSync(content);
  _log('  ✏️  Written: $path');
}

void _log(String message) => stdout.writeln(message);

Never _abort(String message) {
  stderr.writeln('❌ $message');
  exit(1);
}
