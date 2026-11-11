import '../functions/shared/sort_imports.dart';

String initServiceTemplate(String utilsImport, String localizationImport) =>
    '''
${sortImports(["import 'package:flutter/foundation.dart';", "import 'package:flutter_bloc/flutter_bloc.dart';", "import '$localizationImport';", "import '$utilsImport';"])}

import 'di/di_container.dart';
import 'di/di_initializer.dart';

class InitService {
  Future<void> init() async {
    try {
      LocaleSettings.useDeviceLocale();
      Debouncer.showLogs = kDebugMode;
      await diInitializer(diContainer);
      Bloc.observer = diContainer();
    } on Exception catch (e, s) {
      AppLogger.error(e, error: e, stackTrace: s, time: .now());
    }
  }
}
''';
