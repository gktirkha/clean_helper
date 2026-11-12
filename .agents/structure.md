# Repository Structure

Each file under `lib/src/` holds one public symbol, named after the file. Update this list whenever you add, rename or remove a file.

```
clean_helper/
├── bin/
│   └── clean_helper.dart              the only entry point: CleanHelperRunner().run(args)
├── lib/
│   ├── clean_helper.dart              exports lib/src/commands/*.dart only
│   └── src/
│       ├── runner/
│       │   ├── clean_helper_runner.dart          CleanHelperRunner — --scope, --version, registers every command
│       │   └── commands/<command>_command.dart   one args Command class per CLI command
│       ├── commands/                  one entry-point function per command
│       ├── functions/                 helpers, grouped by command
│       └── templates/                 generated file contents
├── .agents/                           these docs
├── CHANGELOG.md
├── README.md                          user-facing docs
└── pubspec.yaml                       version must equal toolVersion
```

---

## `lib/src/commands/`

| File | Function | Command |
|---|---|---|
| `add_entity.dart` | `addEntity(args, {runBuildRunnerAfter})` | `add-entity` |
| `add_feature.dart` | `addFeature(args, {withDi, runBuildRunnerAfter})` | `add-feature` |
| `create_packages.dart` | `createPackages({dir})` — skips `ensurePubspec()` | `create-packages` |
| `add_config.dart` | `addConfig()` — skips `ensurePubspec()` | `add-config` |
| `add_vscode_extensions.dart` | `addVscodeExtensions()` — skips `ensurePubspec()` | `add-vscode-extensions` |
| `add_melos_config.dart` | `addMelosConfig()` — skips `ensurePubspec()` | `add-melos-config` |
| `add_network_module.dart` | `addNetworkModule({runBuildRunnerAfter})` | `add-network-module` |
| `add_repo.dart` | `addRepo(args, {runBuildRunnerAfter, noRest, addSample})` | `add-repo` |
| `bootstrap.dart` | `runBootstrapCommand()` (async) | `bootstrap` |
| `build_runner.dart` | `runBuildRunnerCommand(args)` | `build-runner` |
| `generate_localizations.dart` | `runGenerateLocalizationsCommand()` | `generate-localizations` |
| `generate_tools.dart` | `generateTools({overwrite})` | `generate-tools` |
| `init.dart` | `runInit({withNetwork, withDi, withTools})` (async) | `init` |
| `list_mono_repo_apps.dart` | `listMonoRepoApps()` — skips `ensurePubspec()` | `list-mono-repo-apps` |
| `print_version.dart` | `printVersion()` | global `--version` |
| `regenerate_router.dart` | `regenerateRouter()` | `regenerate-router` |
| `remove_feature.dart` | `removeFeature(args)` | `remove-feature` |

---

## `lib/src/functions/`

### `shared/` — used by every command

| File | Symbol | Purpose |
|---|---|---|
| `abort.dart` | `abort(message)` → `Never` | Print `❌` and exit 1 |
| `camel_case.dart` | `camelCase` | `user_profile` → `userProfile` |
| `pascal_case.dart` | `pascalCase` | → `UserProfile` |
| `kebab_case.dart` | `kebabCase` | → `user-profile` |
| `sort_imports.dart` | `sortImports(imports)` | Join import directives alphabetically |
| `ensure_pubspec.dart` | `ensurePubspec()` | First call of every command: config → monorepo → version check |
| `load_package_configs.dart` | `loadPackageConfigs()` | Fill the config globals from the starting-directory pubspec |
| `package_configs.dart` | `PackageConfig` typedef `(name, import, create)`; `packageConfigsLoaded`, `packageCreateConfig`, `overwriteAnalysisOptionsConfig`, `networkModuleNameConfig`, `networkAuthInterceptorConfig`, `useRootAnalysisConfig`, `monoRepoAppPath`, `utilsPackageConfig`, `networkPackageConfig`, `localizationPackageConfig`, `routerPackageConfig`, `utilsModuleNameConfig`, `callAdapterNameConfig`, `slangSettingsConfig`, `resultTypeConfig` | Config globals |
| `read_clean_helper_fields.dart` | `readCleanHelperFields(path)` | Scalar children of `clean-helper.<path…>` |
| `read_package_config.dart` | `readPackageConfig(key)` | `packages.<key>` → `PackageConfig?` |
| `resolve_utils_package.dart` | `resolveUtilsPackage()` | Configured utils package or `<app>_utils` |
| `resolve_localization_package.dart` | `resolveLocalizationPackage()` | Configured localization package or `<app>_localization` |
| `resolve_router_package.dart` | `resolveRouterPackage()` | Configured router package or `clean_router` |
| `resolve_slang_settings.dart` | `resolveSlangSettings()` | slang defaults + `slangSettingsConfig` |
| `resolve_network_package.dart` | `resolveNetworkPackage()` | Configured network package or `<app>_network` |
| `resolve_network_module_name.dart` | `resolveNetworkModuleName(network)` | `module_name` ?? `<NetworkPascal>Module` |
| `resolve_utils_module_name.dart` | `resolveUtilsModuleName(utils)` | `module_name` ?? `<UtilsPascal>Module` |
| `resolve_call_adapter_name.dart` | `resolveCallAdapterName()` | `call_adapter_name` ?? `RetrofitCallAdapter` |
| `write_package_analysis_options.dart` | `writePackageAnalysisOptions(packageDirs)` | Each existing package's `include:` file (current project's or root's rules), via `writeAnalysisOptions` |
| `write_analysis_options.dart` | `writeAnalysisOptions(path, content)` | `overwriteFile` or, with `overwrite_analysis_options: false`, `writeFile` |
| `app_router_module_path.dart` | `appRouterModulePath()` | `lib/app/router/<app>_router_module.dart` for the current app |
| `analysis_options_include.dart` | `analysisOptionsInclude(dir)` | `include:` path for a project's `analysis_options.yaml`, or null for full rules |
| `package_barrel_path.dart` | `packageBarrelPath(package, [parentDir])` | `<parentDir>/<name>/lib/<file from import>`, `parentDir` defaulting to `packages` |
| `package_barrel_prefix.dart` | `packageBarrelPrefix(package)` | `../` prefix from a nested barrel back to `lib/` |
| `read_mono_repo_apps.dart` | `readMonoRepoApps()` | `mono_repo_apps` list |
| `read_package_name.dart` | `readPackageName()` | `name:` from the current pubspec |
| `resolve_mono_repo_project.dart` | `resolveMonoRepoProject()` | No `lib/`? Select an app and `chdir` into it |
| `prompt_project_selection.dart` | `promptProjectSelection(apps, {title})` | Numbered stdin prompt |
| `scope_option.dart` | `resolveScope` | `--scope` value |
| `check_version_mismatch.dart` | `checkVersionMismatch()` | Warn if `clean-helper.version` ≠ `toolVersion` |
| `tool_version.dart` | `toolVersion` | Must equal pubspec `version:` |
| `write_file.dart` | `writeFile`, `overwriteFile` | The only way to write target files |
| `insert_sorted_import.dart` | `insertSortedImport(content, line)` | Patch helper — adds an import at its sorted place within its `dart:` / `package:` / relative section |
| `run_command.dart` | `runCommand(cmd, {workingDirectory})` | Run a process; on failure print its output and abort |
| `run_command_streamed.dart` | `runCommandStreamed(cmd)` | Same, streaming output |
| `fvm_exec.dart` | `fvmExec(exe)` | `['fvm', exe]` or `[exe]` |
| `fvm_use.dart` | `fvmUse()` (async) | Interactive `fvm use`; skipped when `monoRepoAppPath` is set |

### `init/` — `runInit()` and helpers reused by other commands

| File | Function |
|---|---|
| `generate_analysis_options.dart` | `generateAnalysisOptions()` — full rules, or an include of the root's with `use_root_analysis` in a monorepo app; via `writeAnalysisOptions` |
| `run_flutter_pub_get.dart` | `runFlutterPubGet()` |
| `create_directories.dart` | `createDirectories()` — the only place allowed to call `Directory.createSync` |
| `generate_flutter_gen_files.dart` | `generateFlutterGenFiles()` |
| `scaffold_package.dart` | `scaffoldPackage(package, {parentDir})` — creates `parentDir`, `flutter create --template package --no-pub`, delete unused scaffold files, write an including `analysis_options.yaml` |
| `generate_clean_router_package.dart` | `generateCleanRouterPackage(router, {parentDir})` — `lib/src/<name>_base.dart`, `<name>_refresh.dart` |
| `generate_localization_package.dart` | `generateLocalizationPackage(localization, slangSettings, {parentDir})` |
| `generate_utils_package.dart` | `generateUtilsPackage(utils, localization, {moduleName, translateVar, callAdapterName, parentDir})` |
| `generate_network_package.dart` | `generateNetworkPackage(network, utils, {moduleName, auth, parentDir})` |
| `patch_package_pubspec.dart` | `patchPackagePubspec(packagePath, pubspecTail)` |
| `add_packages_workspace.dart` | `addPackagesWorkspace(packagePaths)` — no-op for an empty list; then `warnStaleWorkspaceEntries` |
| `warn_stale_workspace_entries.dart` | `warnStaleWorkspaceEntries(pubspec)` — warns about `workspace:` paths without a `pubspec.yaml` |
| `generate_core_files.dart` | `generateCoreFiles(packageName, {utils, localization, router})` |
| `generate_tools_files.dart` | `generateToolsFiles({overwrite})` |
| `install_dependencies.dart` | `installDependencies(workspacePackages)` |
| `update_gitignore.dart` | `updateGitignore()` |
| `add_flutter_assets_to_pubspec.dart` | `addFlutterAssetsToPubSpec()` |
| `generate_network_files.dart` | `generateNetworkFiles(utilsImport, {callAdapterName})` |
| `run_slang.dart` | `runSlang(localizationPackageName, {parentDir})` |
| `run_build_runner.dart` | `runBuildRunner({workingDirectory})` |
| `run_dart_format.dart` | `runDartFormat()` |
| `sort_pubspec_deps.dart` | `sortPubspecDeps([path])` |
| `write_tool_version.dart` | `writeToolVersion()` |

### `feature/` — `add-feature`

`create_feature_structure.dart` → `createFeatureStructure(basePath, feature, utilsImport, router, {withDi})` (also used by `init` for the home feature); aborts when the feature is named after the app, since both would generate `<AppPascal>Router` calls the `generateFeature*` helpers: `routes`, `navigation`, `navigation_impl`, `page`, `page_provider`, `router`, `bloc`, `module`. `patch_router_module.dart` → `patchRouterModule(feature)`. `build_router_module.dart` → `buildRouterModule(features)`, which sorts features and is the single source of `<app>_router_module.dart` content.

### `repo/` — `add-repo`

| File | Function |
|---|---|
| `generate_domain_repo.dart` | `generateDomainRepo(dir, name, utilsImport, {addSample})` |
| `generate_data_source_base.dart` | `generateDataSourceBase(dataDir, name, utilsImport, {addSample})` |
| `generate_data_repo.dart` | `generateDataRepo(dataDir, name, utilsImport, {addSample})` |
| `generate_rest_data_source.dart` | `generateRestDataSource(dataDir, feature, name, utilsImport, {callAdapter, addSample})` |
| `generate_use_cases.dart` | `generateUseCases(feature, name, utilsImport)` |
| `generate_api_paths.dart` | `generateApiPaths(dataDir, feature, name)` |
| `generate_request_model.dart` / `generate_response_model.dart` | request/response models |

### Other groups

| Folder | Files → functions |
|---|---|
| `entity/` | `generateEntityFile(dir, name)`, `generateModelFile(dir, name, entityImport)` |
| `add_network_module/` | `generateNetworkAppFiles(networkImport, utilsImport, {auth})`, `installNetworkDependencies(networkName)`, `patchDiInitializer(packageImport, packageModule)`, `patchDioLensInit()` |
| `remove_feature/` | `deleteFeatureFiles(feature)`, `unpatchRouterModule(feature)` |
| `build_runner/` | `runBuildRunnerBuild()`, `runBuildRunnerClean()` |
| `config/` | `addConfigToPubspec()`, `findMonoRepoApps()` |
| `vscode/` | `writeVscodeExtensions()` |
| `melos/` | `installMelos()`, `addMelosToPubspec()` |

---

## `lib/src/templates/`

Each file is `<name>_template.dart` → `<name>Template(...)`.

| Area | Templates |
|---|---|
| App skeleton | `main_dart`, `main_app_dart`, `bootstrap_dart`, `init_service`, `di_container`, `di_initializer`, `app_module`, `core_module`, `app_go_router`, `app_go_router_redirect`, `app_router_module_build` (via `buildRouterModule`) |
| Feature | `feature_routes`, `feature_navigation`, `feature_navigation_impl`, `feature_router`, `feature_page`, `feature_page_provider`, `feature_bloc`, `feature_event`, `feature_state`, `feature_module` |
| Repo | `domain_repo`, `data_source_base`, `data_repo`, `rest_data_source`, `feature_api_paths`, `request_model`, `response_model`, `get_use_case`, `post_use_case`, `get_use_case_params`, `post_use_case_params` |
| Entity | `entity`, `model` |
| Network package | `network_lib_export`, `network_pubspec_tail`, `network_package_module`, `network_config`, `network_di_keys`, `error_interceptor`, `retrofit_logger`, `auth_interceptor` |
| App network files | `core_api_paths`, `error_model`, `app_error_interceptor`, `network_config_module`, `app_auth_interceptor`, `dio_lens_init` |
| Utils package | `utils_lib_export`, `utils_pubspec_tail`, `context_utils`, `di_container` (shared with the app), `utils_module`, `micro_package_di_initializer` (shared with the network package), `retrofit_call_adapter`, `app_logger`, `app_bloc_observer`, `debounce`, `error_entity`, `failure`, `type_definitions`, `get_current_function_name`, `list_to_model_list`, `safe_cast`, `safe_execute`, `safe_execute_task`, `use_case_base` |
| Localization package | `localization_lib_export`, `localization_pubspec_tail`, `localization_slang_yaml`, `string_extension`, `en_locale` |
| clean_router package | `clean_router_base`, `clean_router_refresh`, `clean_router_lib_export`, `clean_router_pubspec_tail` |
| Project config | `analysis_options`, `analysis_options_include`, `build_yaml`, `colors_xml`, `gitignore` |
| Tools | `tools_command_runner`, `tools_clean`, `tools_bootstrap`, `tools_write_key_properties`, `tools_build_android`, `tools_build_config` |
| Melos | `melos_config` |
| Config | `clean_helper_config` (`version`, `apps`) |
| VS Code | `vscode_extensions` (`recommendations`) + the `vscodeRecommendedExtensions` list |

Templates that take configurable input:

| Template | Parameters beyond names |
|---|---|
| `domain_repo`, `data_source_base`, `data_repo` | `utilsImport`, `addSample` |
| `rest_data_source` | `utilsImport`, `callAdapter`, `addSample` |
| `get_use_case`, `post_use_case` | `utilsImport` |
| `dio_lens_init` | `indent` |
| `retrofit_call_adapter` | `className` |
| `retrofit_logger`, `error_model`, `error_interceptor` | `utilsImport` |
| `app_error_interceptor` | `networkImport`, `utilsImport` |
| `network_package_module` | `moduleName`, `auth` |
| `network_lib_export` | barrel `prefix`, `auth` |
| `network_config_module` | `networkImport`, `auth` |
| `app_auth_interceptor` | `networkImport` |
| `network_pubspec_tail` | `utilsPackageName` |
| `di_initializer` | `utilsImport`, `utilsPackageModule` |
| `init_service` | `utilsImport`, `localizationImport` |
| `app_go_router` | `appName`, `routerImport`, `routerPrefix` (`<RouterPascal>`) |
| `feature_router` | `routerImport`, `routerPrefix` |
| `app_go_router_redirect` | `appName`, `routerPrefix` |
| `app_router_module_build` | `appName`, `features` |
| `main_app_dart` | `appName`, `localizationImport` |
| `clean_router_base`, `clean_router_refresh` | class `prefix` (`<RouterPascal>`) |
| `utils_lib_export` | barrel `prefix` |
| `clean_router_lib_export` | package `name` (file names), barrel `prefix` |
| `localization_lib_export` | `generatedFile`, barrel `prefix` |
| `localization_slang_yaml` | slang settings map |
| `string_extension` | `generatedFile`, `translateVar` |
| `safe_cast` | `localizationImport`, `translateVar` |
| `utils_module` | full `moduleName` |
| `feature_navigation_impl` | `utilsImport` |
| `tools_bootstrap` | `localizationDir`, `buildDirs` (only packages under `packages/`) |
