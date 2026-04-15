import 'clean.dart';
import 'command_runner.dart';

Future<void> main() async {
  await clean();
  final hasFvm = await fvmExists();
  final prefix = hasFvm ? 'fvm ' : '';
  if (hasFvm) await commandRunner('fvm use --skip-pub-get');
  await commandRunner('${prefix}flutter pub get');
  await commandRunner('${prefix}dart run slang');
  await commandRunner('${prefix}dart run build_runner build --delete-conflicting-outputs');
}
