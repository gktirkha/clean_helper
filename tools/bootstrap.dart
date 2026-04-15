import 'clean.dart';
import 'command_runner.dart';

Future<void> main() async {
  await clean();
  await commandRunner('fvm use --skip-pub-get');
  await commandRunner('fvm flutter pub get');
  await commandRunner('fvm dart run slang');
  await commandRunner(
    'fvm dart run build_runner build --delete-conflicting-outputs',
  );
}
