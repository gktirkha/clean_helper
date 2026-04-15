String toolsBuildAndroidTemplate() => '''
import 'dart:io';

import 'clean.dart';
import 'command_runner.dart';
import 'write_key_properties.dart';

const _configPath = 'tools/config/android_build_config.json';

Future<void> main(List<String> args) async {
  if (args.contains('--clean')) {
    final configBackup = _backupConfig();
    await clean();
    _restoreConfig(configBackup);
  }

  writeKeyProperties();
  buildAndroid(args);
}

String? _backupConfig() {
  final file = File(_configPath);
  if (file.existsSync()) return file.readAsStringSync();
  return null;
}

void _restoreConfig(String? content) {
  if (content == null) return;
  final file = File(_configPath);
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(content);
  stdout.writeln('♻️  Restored \$_configPath');
}

// TODO: Implement the actual Android build logic.
// Example: run `flutter build appbundle --release` or `flutter build apk --release`.
void buildAndroid(List<String> args) {
  // TODO: implement buildAndroid
  throw UnimplementedError('buildAndroid() is not yet implemented');
}
''';
