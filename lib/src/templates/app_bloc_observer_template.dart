String appBlocObserverTemplate() => '''
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    log('\${bloc.runtimeType} Created', name: 'BlocObserver');
    super.onCreate(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    log(
      'Event in \${bloc.runtimeType} \\n Current State: \${bloc.state} \\n Event Type: \${event.runtimeType} \\n Event Data: \$event',
      name: 'BlocObserver',
    );
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    log(
      'Transition in \${bloc.runtimeType} \\n Current State Type: \${transition.currentState.runtimeType} \\n Next State Type: \${transition.nextState.runtimeType} \\n Details: \$transition',
      name: 'BlocObserver',
    );
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log(
      'Error in \${bloc.runtimeType} \\n Error Type: \${error.runtimeType} \\n Error Data: \$error \\n StackTrace: \$stackTrace',
      name: 'BlocObserver',
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    log('\${bloc.runtimeType} is closed', name: 'BlocObserver');
    super.onClose(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    log(
      'Change in \${bloc.runtimeType} \\n Current State Type: \${change.currentState.runtimeType} \\n Next State Type: \${change.nextState.runtimeType} \\n Details: \$change',
      name: 'BlocObserver',
    );
    super.onChange(bloc, change);
  }
}
''';
