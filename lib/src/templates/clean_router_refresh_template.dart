String cleanRouterRefreshTemplate() => '''
import 'dart:async';

import 'package:flutter/foundation.dart';

class CleanRouterRefresh extends ChangeNotifier {
  CleanRouterRefresh(List<Stream<dynamic>> streams) {
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
