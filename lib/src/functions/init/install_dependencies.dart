import '../shared/log.dart';
import '../shared/run_command.dart';

void installDependencies() {
  log('📦 Installing dependencies...');

  final deps = [
    'flutter_bloc',
    'go_router',
    'get_it',
    'injectable',
    'freezed_annotation',
    'fpdart',
    'slang',
    'slang_flutter',
    'dio',
    'retrofit',
    'json_annotation',
    'package_info_plus',
    'flutter_svg',
    'pretty_dio_logger',
  ];

  final devDeps = [
    'build_runner',
    'injectable_generator',
    'freezed',
    'retrofit_generator',
    'json_serializable',
    'flutter_gen_runner',
  ];

  runCommand(['flutter', 'pub', 'add', 'flutter_localizations', '--sdk=flutter']);
  runCommand(['dart', 'pub', 'add', ...deps]);
  runCommand(['dart', 'pub', 'add', '--dev', ...devDeps]);

  log('📦 Dependencies installed');
}
