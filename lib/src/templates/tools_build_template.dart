String toolsBuildTemplate() => '''
import 'dart:io';

import 'command_runner.dart';

// TODO: Set your keystore path (e.g. '~/keys/upload.jks' or '/home/user/keys/upload.jks')
const _jksPath = '';

// TODO: Set your keystore password
const _password = '';

const _keyAlias = 'upload';

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

void _writeKeyProperties() {
  final resolvedPath = _resolvePath(_jksPath);
  final content =
      'storePassword=\$_password\\n'
      'keyPassword=\$_password\\n'
      'keyAlias=\$_keyAlias\\n'
      'storeFile=\$resolvedPath\\n';
  File('android/key.properties').writeAsStringSync(content);
  stdout.writeln('🔑 android/key.properties written');
}

String _resolvePath(String path) {
  if (path.startsWith('~/')) {
    final home =
        Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        '';
    return '\$home/\${path.substring(2)}';
  }
  return path;
}
''';
