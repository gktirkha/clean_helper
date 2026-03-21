import 'dart:io';

void patchAppGoRouter() {
  const path = 'lib/app/router/app_go_router.dart';
  final file = File(path);

  if (!file.existsSync()) {
    stderr.writeln('⚠️  $path not found, skipping Chucker observer patch');
    return;
  }

  var content = file.readAsStringSync();

  const chuckerImport = "import 'package:chucker_flutter/chucker_flutter.dart';";
  if (!content.contains(chuckerImport)) {
    content = content.replaceFirst(
      "import 'package:flutter/material.dart';",
      "$chuckerImport\nimport 'package:flutter/material.dart';",
    );
  }

  const chuckerObserver = '    observers: [ChuckerFlutter.navigatorObserver],\n';
  if (!content.contains('ChuckerFlutter.navigatorObserver')) {
    content = content.replaceFirst(
      '    refreshListenable: GoRouterRefreshStream(',
      '$chuckerObserver    refreshListenable: GoRouterRefreshStream(',
    );
  }

  file.writeAsStringSync(content);
  stdout.writeln('🔍 Chucker observer added to $path');
}
