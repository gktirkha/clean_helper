String routerRefreshTemplate() => '''
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
