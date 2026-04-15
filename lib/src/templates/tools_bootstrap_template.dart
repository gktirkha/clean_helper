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
  final prefix = await fvmPrefix();
  if (prefix.isNotEmpty) await commandRunner('fvm use --skip-pub-get');
  await commandRunner('\${prefix}flutter pub get');
  await commandRunner('\${prefix}dart run slang');
  await commandRunner(
    '\${prefix}dart run build_runner build --delete-conflicting-outputs',
  );
}
''';
