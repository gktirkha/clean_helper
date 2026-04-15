String toolsWriteKeyPropertiesTemplate() => '''
import 'dart:convert';
import 'dart:io';

const _configPath = 'tools/config/android_build_config.json';

void writeKeyProperties() {
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

Map<String, String> _loadConfig() {
  final config = <String, String>{
    'jksPath': '',
    'storePassword': '',
    'keyPassword': '',
    'keyAlias': 'upload',
  };

  final configFile = File(_configPath);
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

String _resolvePath(String path) {
  final trimmed = path.trim();
  if (trimmed.startsWith('~/')) {
    final home =
        Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        '';
    return '\$home/\${trimmed.substring(2)}'.replaceAll('\\\\', '/');
  }
  return trimmed.replaceAll('\\\\', '/');
}
''';
