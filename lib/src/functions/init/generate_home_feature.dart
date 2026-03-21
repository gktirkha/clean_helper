import 'dart:io';

import '../shared/write_file.dart';

void generateHomeFeature(String packageName) {
  const basePath = 'lib/features/home';

  writeFile('$basePath/router/home_routes.dart', '''
sealed class HomeRoutes {
  static const String home = '/home';
}
''');

  writeFile('$basePath/router/home_navigation.dart', '''
import 'package:flutter/material.dart';

abstract class HomeNavigation {
  void goToHome(BuildContext context);
}
''');

  writeFile('lib/app/navigations/home_navigation_impl.dart', '''
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

  writeFile('$basePath/router/home_router.dart', '''
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

  writeFile('$basePath/presentation/pages/home_page.dart', '''
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

  writeFile('$basePath/presentation/bloc/home/home_bloc.dart', '''
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

  writeFile('$basePath/presentation/bloc/home/home_event.dart', '''
part of 'home_bloc.dart';

@freezed
abstract class HomeEvent with _\$HomeEvent {
  const factory HomeEvent.started() = _Started;
}
''');

  writeFile('$basePath/presentation/bloc/home/home_state.dart', '''
part of 'home_bloc.dart';

@freezed
abstract class HomeState with _\$HomeState {
  const factory HomeState.initial() = _Initial;
}
''');

  stdout.writeln('🏠 Home feature generated');
}
