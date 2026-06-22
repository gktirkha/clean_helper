import '../functions/init/run_build_runner.dart';
import '../functions/init/run_flutter_pub_get.dart';
import '../functions/init/run_slang.dart';
import '../functions/shared/ensure_pubspec.dart';
import '../functions/shared/fvm_use.dart';
import '../functions/shared/read_package_name.dart';

Future<void> runBootstrapCommand() async {
  ensurePubspec();
  await fvmUse();
  runFlutterPubGet();
  runSlang('${readPackageName()}_localization');
  runBuildRunner();
}
