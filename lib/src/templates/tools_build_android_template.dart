String toolsBuildAndroidTemplate() => '''
import 'bootstrap.dart';
import 'write_key_properties.dart';

Future<void> main(List<String> args) async {
  if (args.contains('--clean')) {
    await bootstrap(args);
  }

  writeKeyProperties();
  buildAndroid(args);
}

// TODO: Implement the actual Android build logic.
void buildAndroid(List<String> args) {}
''';
