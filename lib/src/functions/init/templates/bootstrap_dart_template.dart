String bootstrapDartTemplate(String pkg) => '''
import 'package:flutter/material.dart';

import 'di/di_container.dart';
import 'di/di_initializer.dart';
import '../core/generated/locales/locales.g.dart';
import 'main_app.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  await diInitializer(diContainer);
  runApp(const MainApp());
}
''';
