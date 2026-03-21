import '../shared/log.dart';
import '../shared/run_command.dart';

void addChuckerDependency() {
  runCommand([
    'flutter',
    'pub',
    'add',
    'chucker_flutter',
    '--git-url=https://github.com/gktirkha/chucker-flutter.git',
  ]);
  log('🔍 Chucker dependency added');
}
