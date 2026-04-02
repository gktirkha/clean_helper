String bootstrapDartTemplate(String pkg) => '''
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/utils/functions/debouncer.dart';
import '../generated/locales/locales.g.dart';
import 'di/di_container.dart';
import 'di/di_initializer.dart';
import 'main_app.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  Debouncer.showLogs = kDebugMode;
  await diInitializer(diContainer);
  runApp(const MainApp());
}
''';
