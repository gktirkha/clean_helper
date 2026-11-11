/// A workspace package declared under `clean-helper.packages.<key>` in the
/// pubspec the command was started from.
///
/// [import] is the barrel import URI, e.g. `package:my_utils/my_utils.dart`.
/// [create] is whether `init` generates the package under `packages/<name>`;
/// false means it already exists elsewhere in the workspace.
typedef PackageConfig = ({String name, String import, bool create});

/// Set by [loadPackageConfigs]. [ensurePubspec] loads config only once per
/// process: commands that call other commands (`init` → `add-network-module`)
/// run `ensurePubspec()` again from inside the monorepo app, whose pubspec
/// doesn't hold the root config.
bool packageConfigsLoaded = false;

/// `clean-helper.packages.utils`, set by [loadPackageConfigs].
/// Null means the default `<app>_utils` package (see [resolveUtilsPackage]).
PackageConfig? utilsPackageConfig;

/// `clean-helper.packages.network`, set by [loadPackageConfigs].
/// Null means networking is detected from `lib/core/network/`.
PackageConfig? networkPackageConfig;

/// `clean-helper.packages.localization`, set by [loadPackageConfigs].
/// Null means the default `<app>_localization` package.
PackageConfig? localizationPackageConfig;

/// `clean-helper.packages.router`, set by [loadPackageConfigs].
/// Null means the default `clean_router` package.
PackageConfig? routerPackageConfig;

/// `clean-helper.packages.utils.module_name`, set by [loadPackageConfigs]:
/// the utils package's `@module` class. Null means `<UtilsPascal>Module`.
String? utilsModuleNameConfig;

/// `clean-helper.packages.utils.call_adapter_name`, set by
/// [loadPackageConfigs]: the call adapter class `add-network-module`
/// generates and `add-repo` uses. Null means `RetrofitCallAdapter`.
String? callAdapterNameConfig;

/// Slang settings under `clean-helper.packages.localization` (every scalar
/// key except `name`, `import` and `create`), set by [loadPackageConfigs].
/// Missing keys use the defaults in [resolveSlangSettings].
Map<String, String> slangSettingsConfig = {};

/// `clean-helper.packages.use_root_analysis` (or `clean-helper.use_root_analysis`),
/// set by [loadPackageConfigs]. True means apps and packages include the
/// workspace root's `analysis_options.yaml` instead of the nearest project's.
bool useRootAnalysisConfig = false;

/// `clean-helper.packages.vs_code_configs` (or `clean-helper.vs_code_configs`),
/// set by [loadPackageConfigs]: which `.vscode/` files `add-vscode-config`
/// writes. A missing key means true.
({bool extensions, bool tasks, bool launch}) vscodeConfig = (
  extensions: true,
  tasks: true,
  launch: true,
);

/// The monorepo app [resolveMonoRepoProject] switched into, relative to the
/// starting directory (e.g. `apps/shop`). Null when no switch happened.
String? monoRepoAppPath;

/// `clean-helper.result_type` (`task_either` or `future_either`), set by
/// [loadPackageConfigs]. Null means `task_either`.
String? resultTypeConfig;
