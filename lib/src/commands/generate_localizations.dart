import '../functions/shared/ensure_pubspec.dart';
import '../functions/generate_localizations/run_generate_localizations.dart';

void runGenerateLocalizationsCommand(List<String> args) {
  ensurePubspec();
  runGenerateLocalizations();
}
