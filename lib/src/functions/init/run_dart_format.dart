import '../shared/log.dart';
import '../shared/run_command.dart';

void runDartFormat() {
  log('🎨 Formatting code...');
  runCommand(['dart', 'format', '.']);
  log('🎨 Formatting complete');
}
