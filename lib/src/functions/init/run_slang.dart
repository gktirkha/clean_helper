import '../shared/log.dart';
import '../shared/run_command.dart';

void runSlang() {
  log('🌐 Running slang...');
  runCommand(['dart', 'run', 'slang']);
  log('🌐 Slang generation complete');
}
