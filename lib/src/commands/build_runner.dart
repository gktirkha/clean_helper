import 'dart:io';

import '../functions/build_runner/run_build_runner_build.dart';
import '../functions/build_runner/run_build_runner_clean.dart';
import '../functions/shared/ensure_pubspec.dart';

void runBuildRunnerCommand(List<String> args) {
  ensurePubspec();

  final action = args.isEmpty ? 'build' : args.first;

  switch (action) {
    case 'clean':
      runBuildRunnerClean();
    case 'build':
      runBuildRunnerBuild();
    default:
      stderr.writeln('❌ Unknown action "$action". Use: clean | build');
      exit(1);
  }
}
