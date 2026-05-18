String appBlocObserverTemplate() => '''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../core/utils/app_logger.dart';

@LazySingleton(as: BlocObserver)
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    AppLogger.debug('\${bloc.runtimeType} Created');
    super.onCreate(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    AppLogger.debug(
      'Event in \${bloc.runtimeType} \\n Current State: \${bloc.state} \\n Event Type: \${event.runtimeType} \\n Event Data: \$event',
    );
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    AppLogger.debug(
      'Transition in \${bloc.runtimeType} \\n Current State Type: \${transition.currentState.runtimeType} \\n Next State Type: \${transition.nextState.runtimeType} \\n Details: \$transition',
    );
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    AppLogger.error(
      'Error in \${bloc.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    AppLogger.debug('\${bloc.runtimeType} is closed');
    super.onClose(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    AppLogger.debug(
      'Change in \${bloc.runtimeType} \\n Current State Type: \${change.currentState.runtimeType} \\n Next State Type: \${change.nextState.runtimeType} \\n Details: \$change',
    );
    super.onChange(bloc, change);
  }
}
''';
