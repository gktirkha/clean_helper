/// `<prefix>Refresh`: merges the routers' refresh streams for go_router.
String cleanRouterRefreshTemplate(String prefix) =>
    '''
import 'dart:async';

import 'package:flutter/foundation.dart';

class ${prefix}Refresh extends ChangeNotifier {
  ${prefix}Refresh(List<Stream<dynamic>> streams) {
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
