/// `lib/src/di/di_initializer.dart` of a package that registers its own
/// dependencies as an injectable micro-package (`<PackagePascal>PackageModule`).
String microPackageDiInitializerTemplate() => '''
import 'package:injectable/injectable.dart';

@InjectableInit.microPackage(preferRelativeImports: true)
void initMicroPackage() {}
''';
