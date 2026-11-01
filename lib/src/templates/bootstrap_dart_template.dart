String bootstrapDartTemplate() => '''
import 'package:flutter/material.dart';

import 'init_service.dart';
import 'main_app.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InitService().init();
  runApp(const MainApp());
}
''';
