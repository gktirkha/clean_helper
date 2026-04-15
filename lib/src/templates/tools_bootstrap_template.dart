String toolsBootstrapTemplate() => '''
import 'clean.dart';
import 'command_runner.dart';

Future<void> main(List<String> args) async {
  ensureProjectRoot();
  await bootstrap(args);
}

Future<void> bootstrap(
  List<String> args, {
  List<String> preserveFiles = const [],
}) async {
  if (args.contains('--clean')) await clean(preserveFiles: preserveFiles);
  await fvmUse();
  await fvmRunner('flutter pub get');
  await fvmRunner('dart run slang');
  await fvmRunner(
    'dart run build_runner build --delete-conflicting-outputs',
  );
}
''';
