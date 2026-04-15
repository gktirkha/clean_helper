String toolsBuildAndroidTemplate() => '''
import 'dart:convert';
import 'dart:io';

import 'command_runner.dart';

Future<void> main(List<String> args) async {
  final mode = args.isEmpty ? 'aab' : args.first;

  if (!['aab', 'apk', 'both'].contains(mode)) {
    stderr.writeln('[ERROR] Invalid argument: \$mode. Use aab, apk, or both.');
    exit(1);
  }

  _writeKeyProperties();

  final hasFvm = await fvmExists();
  final prefix = hasFvm ? 'fvm ' : '';

  if (mode == 'aab' || mode == 'both') {
    await commandRunner('\${prefix}flutter build appbundle --release');
  }
  if (mode == 'apk' || mode == 'both') {
    await commandRunner('\${prefix}flutter build apk --release');
  }
}

Map<String, String> _loadConfig() {
  final config = <String, String>{
    'jksPath': '',
    'storePassword': '',
    'keyPassword': '',
    'keyAlias': 'upload',
  };

  final configFile = File('tools/config/android_build_config.json');
  if (configFile.existsSync()) {
    final map =
        jsonDecode(configFile.readAsStringSync()) as Map<String, dynamic>;
    config.addAll(map.map((k, v) => MapEntry(k, v.toString())));
  }

  final env = Platform.environment;
  if (env['JKS_PATH'] != null) config['jksPath'] = env['JKS_PATH']!;
  if (env['STORE_PASSWORD'] != null) config['storePassword'] = env['STORE_PASSWORD']!;
  if (env['KEY_PASSWORD'] != null) config['keyPassword'] = env['KEY_PASSWORD']!;
  if (env['KEY_ALIAS'] != null) config['keyAlias'] = env['KEY_ALIAS']!;

  return config;
}

void _writeKeyProperties() {
  final config = _loadConfig();
  final resolvedPath = _resolvePath(config['jksPath'] ?? '');
  final content =
      'storePassword=\${config['storePassword']}\\n'
      'keyPassword=\${config['keyPassword']}\\n'
      'keyAlias=\${config['keyAlias']}\\n'
      'storeFile=\$resolvedPath\\n';
  File('android/key.properties').writeAsStringSync(content);
  stdout.writeln('🔑 android/key.properties written');
}

String _resolvePath(String path) {
  final trimmed = path.trim();
  if (trimmed.startsWith('~/')) {
    final home =
        Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        '';
    return '\$home/\${trimmed.substring(2)}';
  }
  return trimmed;
}
''';
