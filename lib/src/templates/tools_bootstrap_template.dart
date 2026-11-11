/// [localizationDir] is the package to run slang in; [buildDirs] are the
/// packages to run build_runner in before the app (e.g. `packages/my_utils`).
/// Packages outside this project are left out.
String toolsBootstrapTemplate({
  String? localizationDir,
  List<String> buildDirs = const [],
}) {
  final slang = localizationDir == null
      ? ''
      : "\n  await fvmRunner('dart run slang', workingDirectory: '$localizationDir');";
  final packageBuilds = buildDirs
      .map(
        (dir) =>
            "\n  await fvmRunner('dart run build_runner build', workingDirectory: '$dir');",
      )
      .join();
  return '''
import 'clean.dart';
import 'command_runner.dart';

Future<void> main(List<String> args) async {
  ensureProjectRoot();
  await bootstrap(args);
}

Future<void> bootstrap(List<String> args) async {
  if (args.contains('--clean')) {
    await clean();
  }
  await fvmUse();
  await fvmRunner('flutter pub get');$slang$packageBuilds
  await fvmRunner('dart run build_runner build');
}
''';
}
