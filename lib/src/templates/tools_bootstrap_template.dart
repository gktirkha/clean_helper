/// [localizationDir] / [utilsDir] are the workspace packages to run slang /
/// build_runner in first (e.g. `packages/my_app_localization`), or null when
/// they live outside this project.
String toolsBootstrapTemplate({String? localizationDir, String? utilsDir}) {
  final slang = localizationDir == null
      ? ''
      : "\n  await fvmRunner('dart run slang', workingDirectory: '$localizationDir');";
  final utilsBuild = utilsDir == null
      ? ''
      : "\n  await fvmRunner('dart run build_runner build', workingDirectory: '$utilsDir');";
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
  await fvmRunner('flutter pub get');$slang$utilsBuild
  await fvmRunner('dart run build_runner build');
}
''';
}
