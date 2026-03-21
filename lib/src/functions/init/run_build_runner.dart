import '../shared/log.dart';
import '../shared/run_command.dart';

void runBuildRunner() {
  log('🔨 Running build_runner...');
  runCommand([
    'dart',
    'run',
    'build_runner',
    'build',
    '--delete-conflicting-outputs',
  ]);
  log('🔨 Code generation complete');
}
