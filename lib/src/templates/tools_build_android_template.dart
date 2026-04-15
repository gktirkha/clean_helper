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
// Example: run `flutter build appbundle --release` or `flutter build apk --release`.
void buildAndroid(List<String> args) {
  // TODO: implement buildAndroid
  throw UnimplementedError('buildAndroid() is not yet implemented');
}
''';
