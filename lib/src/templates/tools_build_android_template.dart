String toolsBuildAndroidTemplate() => '''
import 'bootstrap.dart';
import 'command_runner.dart';
import 'write_key_properties.dart';

Future<void> main(List<String> args) async {
  ensureProjectRoot();
  if (args.contains('--clean')) {
    await bootstrap(args);
  }
  writeKeyProperties();
  buildAndroid(args);
}

// TODO: Implement the actual Android build logic.
void buildAndroid(List<String> args) {
  fvmRunner('flutter build apk --release');
}
''';
