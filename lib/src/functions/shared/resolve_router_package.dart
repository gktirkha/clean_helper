import 'package_configs.dart';

/// `clean-helper.packages.router`, or the default `clean_router` package
/// (created by `init`).
PackageConfig resolveRouterPackage() =>
    routerPackageConfig ??
    (
      name: 'clean_router',
      import: 'package:clean_router/clean_router.dart',
      create: true,
    );
