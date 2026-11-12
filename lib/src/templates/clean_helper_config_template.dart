/// The `clean-helper:` block `add-config` appends to `pubspec.yaml`: every
/// key with a `##` comment above it; commented-out options use a single `#`. Active values are the defaults, so adding the
/// block changes nothing; app-dependent keys are commented out. [apps] fills
/// `mono_repo_apps` (commented out when empty).
String cleanHelperConfigTemplate({
  required String version,
  List<String> apps = const [],
}) {
  final monoRepoApps = apps.isEmpty
      ? '''
  # mono_repo_apps:
  #   - apps/consumer
  #   - apps/organizer'''
      : '  mono_repo_apps:\n${apps.map((a) => '    - $a').join('\n')}';

  return '''

clean-helper:
  ## Stamped by `init`; every command warns when it differs from the running tool.
  version: $version

  ## Monorepo only: app folders, relative to this pubspec. Commands run from
  ## here switch into one of them (pick with --scope=<folder name>).
$monoRepoApps

  packages:
    ## Shared code: Failure, UseCaseBase, safeExecuteTask, AppLogger, …
    utils:
      ## Package name. Default: <app>_utils.
      # name: my_app_utils
      ## Barrel import; the barrel is written at this path.
      ## Default: package:<name>/<name>.dart.
      # import: package:my_app_utils/my_app_utils.dart
      ## false: init doesn't generate it; it already exists in the workspace.
      ## create-packages ignores this. Default: true.
      create: true
      ## The @module class that registers BlocObserver. Default: <UtilsPascal>Module.
      # module_name: MyAppUtilsModule

    ## slang translations, used by MainApp and InitService.
    localization:
      ## Package name. Default: <app>_localization.
      # name: my_app_localization
      ## Barrel import. Default: package:<name>/<name>.dart.
      # import: package:my_app_localization/my_app_localization.dart
      ## Same as utils.create.
      create: true
      ## Every key below is written to the package's slang.yaml.
      ## Default locale; the first locale file is <base_locale><input_file_pattern>.
      base_locale: en
      fallback_strategy: base_locale
      ## Where the locale files live, inside the package.
      input_directory: assets/locales
      input_file_pattern: .locale.json
      ## Generated code; must be inside lib/. The barrel exports it.
      output_directory: lib/src/generated
      output_file_name: locales.g.dart
      ## Variable used for translations (locales.general.…), in String.tr.
      translate_var: locales

    ## <RouterPascal>Base / <RouterPascal>Refresh (CleanRouterBase by default),
    ## used by <AppPascal>Router and feature routers.
    router:
      ## Package name. Default: clean_router.
      # name: clean_router
      ## Barrel import. Default: package:<name>/<name>.dart.
      # import: package:clean_router/clean_router.dart
      ## Same as utils.create.
      create: true

    ## Dio, NetworkConfig and the auth interceptor, created by
    ## add-network-module and init.
    network:
      ## Package name. Default: <app>_network.
      # name: my_app_network
      ## Barrel import. Default: package:<name>/<name>.dart.
      # import: package:my_app_network/my_app_network.dart
      ## Same as utils.create.
      create: true
      ## The package's @module class. Default: <NetworkPascal>Module.
      # module_name: MyAppNetworkModule
      ## The app's Retrofit call adapter (lib/core/network/adapters/), which
      ## turns errors into ApiFailure; used by add-repo in
      ## @RestApi(callAdapter: …). Default: AppCallAdapter.
      # call_adapter_name: AppCallAdapter
      ## Token handling: abstract AuthInterceptor + noAuthDio in the package,
      ## AppAuthInterceptor in the app. Default: true.
      auth_interceptor: true

    ## true: init and create-packages replace existing analysis_options.yaml
    ## files with the generated ones. false: existing files are kept.
    ## Default: true.
    overwrite_analysis_options: true

    ## Monorepo only. true: apps and packages include the workspace root's
    ## analysis_options.yaml. false: the nearest project's. Default: true.
    use_root_analysis: true
''';
}
