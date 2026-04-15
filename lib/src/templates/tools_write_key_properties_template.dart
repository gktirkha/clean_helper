String toolsWriteKeyPropertiesTemplate() => '''
import 'dart:convert';
import 'dart:io';

Map<String, String> loadConfig() {
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
  if (env['JKS_PATH'] != null) {
    config['jksPath'] = env['JKS_PATH']!;
  }
  if (env['STORE_PASSWORD'] != null) {
    config['storePassword'] = env['STORE_PASSWORD']!;
  }
  if (env['KEY_PASSWORD'] != null) {
    config['keyPassword'] = env['KEY_PASSWORD']!;
  }
  if (env['KEY_ALIAS'] != null) {
    config['keyAlias'] = env['KEY_ALIAS']!;
  }

  return config;
}

void writeKeyProperties() {
  final config = loadConfig();
  final resolvedPath = resolvePath(config['jksPath'] ?? '');
  final content =
      'storePassword=\${config['storePassword']}\\n'
      'keyPassword=\${config['keyPassword']}\\n'
      'keyAlias=\${config['keyAlias']}\\n'
      'storeFile=\$resolvedPath\\n';
  File('android/key.properties').writeAsStringSync(content);
  stdout.writeln('🔑 android/key.properties written');
}

String resolvePath(String path) {
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
