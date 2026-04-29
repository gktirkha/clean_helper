String bootstrapDartTemplate(String pkg) => '''
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  Bloc.observer = diContainer();
  runApp(const MainApp());
}
''';
