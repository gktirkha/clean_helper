# Repository Structure

Each file under `lib/src/` holds one public symbol, named after the file. Update this list whenever you add, rename or remove a file.

```
clean_helper/
├── bin/
│   ├── clean_helper.dart              main entry: CleanHelperRunner().run(args)
│   └── <command>.dart                 legacy per-command entries (init, add_feature, add_repo, …) — each only calls its command function
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
| `add_auth_interceptor.dart` | `addAuthInterceptor({runBuildRunnerAfter, showNextSteps})` | `add-auth-interceptor` |
| `add_entity.dart` | `addEntity(args, {runBuildRunnerAfter})` | `add-entity` |
| `add_feature.dart` | `addFeature(args, {withDi, runBuildRunnerAfter})` | `add-feature` |
| `create_packages.dart` | `createPackages({dir})` — skips `ensurePubspec()` | `create-packages` |
| `add_melos_config.dart` | `addMelosConfig()` — skips `ensurePubspec()` | `add-melos-config` |
| `add_network.dart` | `addNetwork()` | legacy — not registered in the runner |
| `add_network_module.dart` | `addNetworkModule({runBuildRunnerAfter})` | `add-network-module` |
| `add_repo.dart` | `addRepo(args, {runBuildRunnerAfter, noRest, addSample})` | `add-repo` |
| `add_vscode_config.dart` | `addVscodeConfig()` | `add-vscode-config` |
| `bootstrap.dart` | `runBootstrapCommand()` (async) | `bootstrap` |
| `build_runner.dart` | `runBuildRunnerCommand(args)` | `build-runner` |
| `generate_localizations.dart` | `runGenerateLocalizationsCommand(args)` | `generate-localizations` |
| `generate_tools.dart` | `generateTools({overwrite})` | `generate-tools` |
| `init.dart` | `runInit({withNetwork, withDi, withAuthInterceptor, withTools})` (async) | `init` |
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
| `package_configs.dart` | `PackageConfig` typedef `(name, import, create)`; `packageConfigsLoaded`, `vscodeConfig`, `useRootAnalysisConfig`, `monoRepoAppPath`, `utilsPackageConfig`, `networkPackageConfig`, `localizationPackageConfig`, `routerPackageConfig`, `utilsModuleNameConfig`, `callAdapterNameConfig`, `slangSettingsConfig`, `retrofitCallAdapterConfig`, `resultTypeConfig` | Config globals |
| `read_clean_helper_fields.dart` | `readCleanHelperFields(path)` | Scalar children of `clean-helper.<path…>` |
| `read_package_config.dart` | `readPackageConfig(key)` | `packages.<key>` → `PackageConfig?` |
| `resolve_utils_package.dart` | `resolveUtilsPackage()` | Configured utils package or `<app>_utils` |
| `resolve_localization_package.dart` | `resolveLocalizationPackage()` | Configured localization package or `<app>_localization` |
| `resolve_router_package.dart` | `resolveRouterPackage()` | Configured router package or `clean_router` |
| `resolve_slang_settings.dart` | `resolveSlangSettings()` | slang defaults + `slangSettingsConfig` |
| `resolve_utils_module_name.dart` | `resolveUtilsModuleName(utils)` | `module_name` ?? `<UtilsPascal>Module` |
| `resolve_call_adapter_name.dart` | `resolveCallAdapterName()` | `call_adapter_name` ?? `retrofit_call_adapter.name` ?? `RetrofitCallAdapter` |
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
| `run_command.dart` | `runCommand(cmd, {workingDirectory})` | Run a process, abort on failure |
| `run_command_streamed.dart` | `runCommandStreamed(cmd)` | Same, streaming output |
| `fvm_exec.dart` | `fvmExec(exe)` | `['fvm', exe]` or `[exe]` |
| `fvm_use.dart` | `fvmUse()` (async) | Interactive `fvm use` |

### `init/` — `runInit()` and helpers reused by other commands

| File | Function |
|---|---|
| `generate_analysis_options.dart` | `generateAnalysisOptions()` — full rules, or an include of the root's (created if missing) with `use_root_analysis` in a monorepo app |
| `run_flutter_pub_get.dart` | `runFlutterPubGet()` |
| `create_directories.dart` | `createDirectories()` — the only place allowed to call `Directory.createSync` |
| `generate_localization_files.dart` | `generateLocalizationFiles()` — no-op |
| `generate_flutter_gen_files.dart` | `generateFlutterGenFiles()` |
| `scaffold_package.dart` | `scaffoldPackage(package, {parentDir})` — `flutter create --template package`, delete unused scaffold files, write an including `analysis_options.yaml` |
| `generate_clean_router_package.dart` | `generateCleanRouterPackage(router, {parentDir})` |
| `generate_localization_package.dart` | `generateLocalizationPackage(localization, slangSettings, {parentDir})` |
| `generate_utils_package.dart` | `generateUtilsPackage(utils, localization, {moduleName, translateVar, parentDir})` |
| `patch_package_pubspec.dart` | `patchPackagePubspec(packagePath, pubspecTail)` |
| `add_packages_workspace.dart` | `addPackagesWorkspace(packagePaths)` — no-op for an empty list |
| `generate_core_files.dart` | `generateCoreFiles(packageName, {utils, localization, router})` |
| `generate_home_feature.dart` | `generateHomeFeature(utilsImport, routerImport, {withDi})` |
| `generate_tools_files.dart` | `generateToolsFiles({overwrite})` |
| `install_dependencies.dart` | `installDependencies(workspacePackages)` |
| `update_gitignore.dart` | `updateGitignore()` |
| `add_flutter_assets_to_pubspec.dart` | `addFlutterAssetsToPubSpec()` |
| `generate_network_files.dart` | `generateNetworkFiles(utilsImport, {registerErrorLogger, retrofitHelpersInUtils})` |
| `generate_retrofit_call_adapter.dart` | `generateRetrofitCallAdapter(utilsImport)` → `lib/core/network/utils/` |
| `generate_retrofit_logger.dart` | `generateRetrofitLogger(utilsImport)` → `lib/core/network/utils/` |
| `run_slang.dart` | `runSlang(localizationPackageName, {parentDir})` |
| `run_build_runner.dart` | `runBuildRunner({workingDirectory})` |
| `run_dart_format.dart` | `runDartFormat()` |
| `sort_pubspec_deps.dart` | `sortPubspecDeps([path])` |
| `write_tool_version.dart` | `writeToolVersion()` |

### `feature/` — `add-feature`

`create_feature_structure.dart` → `createFeatureStructure(basePath, feature, utilsImport, routerImport, {withDi, contextUtils})` calls the `generateFeature*` helpers: `routes`, `navigation`, `navigation_impl`, `page`, `page_provider`, `router`, `bloc`, `module`. `patch_router_module.dart` → `patchRouterModule(feature)`. `build_router_module.dart` → `buildRouterModule(features)`, which sorts features and is the single source of `app_router_module.dart` content. `utils_has_context_utils.dart` → `utilsHasContextUtils(utils)`: whether `packages/<utils>/lib/src/context_utils.dart` exists.

### `repo/` — `add-repo`

| File | Function |
|---|---|
| `generate_domain_repo.dart` | `generateDomainRepo(dir, name, utilsImport, {addSample, taskEither})` |
| `generate_data_source_base.dart` | `generateDataSourceBase(dataDir, name, utilsImport, {addSample, taskEither})` |
| `generate_data_repo.dart` | `generateDataRepo(dataDir, name, utilsImport, {addSample, taskEither})` |
| `generate_rest_data_source.dart` | `generateRestDataSource(dataDir, feature, name, utilsImport, {callAdapter, adapterImport, ignoreErrorLogger, addSample, taskEither})` |
| `generate_use_cases.dart` | `generateUseCases(feature, name, utilsImport, {importUseCaseBase, taskEither})` |
| `generate_api_paths.dart` | `generateApiPaths(dataDir, feature, name)` |
| `generate_request_model.dart` / `generate_response_model.dart` | request/response models |
| `uses_task_either.dart` | `usesTaskEither()` — from `resultTypeConfig`; aborts on invalid values |
| `utils_has_use_case_base.dart` | `utilsHasUseCaseBase(utils)` — whether `packages/<utils>/lib/src/use_case_base.dart` exists |
| `warn_missing_rest_dependencies.dart` | `warnMissingRestDependencies()` |

### Other groups

| Folder | Files → functions |
|---|---|
| `entity/` | `generateEntityFile(dir, name)`, `generateModelFile(dir, name, entityImport)` |
| `add_network_module/` | `installNetworkDependencies()`, `patchDioLensInit()`, `utilsRegistersErrorLogger(utils)`, `utilsHasRetrofitHelpers(utils)` |
| `auth_interceptor/` | `generateAuthInterceptor()`, `patchDiKeys()`, `patchNetworkModule()` |
| `remove_feature/` | `deleteFeatureFiles(feature)`, `unpatchRouterModule(feature)` |
| `build_runner/` | `runBuildRunnerBuild()`, `runBuildRunnerClean()` |
| `generate_localizations/` | `runGenerateLocalizations()` |
| `melos/` | `installMelos()`, `addMelosToPubspec()` |
| `vscode_config/` | `generateVscodeExtensions()`, `generateVscodeLaunch()`, `generateVscodeTasks()` |

---

## `lib/src/templates/`

Each file is `<name>_template.dart` → `<name>Template(...)`.

| Area | Templates |
|---|---|
| App skeleton | `main_dart`, `main_app_dart`, `bootstrap_dart`, `init_service`, `di_container`, `di_initializer`, `di_keys`, `app_module`, `core_module`, `app_go_router`, `app_go_router_redirect`, `app_router_module`, `app_router_module_build` |
| Feature | `feature_routes`, `feature_navigation`, `feature_navigation_impl`, `feature_router`, `feature_page`, `feature_page_provider`, `feature_bloc`, `feature_event`, `feature_state`, `feature_module` |
| Repo | `domain_repo`, `data_source_base`, `data_repo`, `rest_data_source`, `feature_api_paths`, `request_model`, `response_model`, `get_use_case`, `post_use_case`, `get_use_case_params`, `post_use_case_params` |
| Entity | `entity`, `model` |
| Network | `network_module`, `core_api_paths`, `error_interceptor`, `error_model`, `retrofit_call_adapter`, `retrofit_logger`, `auth_interceptor`, `di_keys_no_auth`, `no_auth_dio_method`, `dio_lens_init` |
| Utils package | `utils_lib_export`, `utils_pubspec_tail`, `context_utils`, `di_container` (shared with the app), `utils_module`, `utils_di_initializer`, `app_logger`, `app_bloc_observer`, `debounce`, `error_entity`, `failure`, `type_definitions`, `get_current_function_name`, `list_to_model_list`, `safe_cast`, `safe_execute`, `safe_execute_task`, `use_case_base` |
| Localization package | `localization_lib_export`, `localization_pubspec_tail`, `localization_slang_yaml`, `string_extension`, `en_locale` |
| clean_router package | `clean_router_base`, `clean_router_refresh`, `clean_router_lib_export`, `clean_router_pubspec_tail` |
| Project config | `analysis_options`, `analysis_options_include`, `build_yaml`, `colors_xml`, `gitignore` |
| Tools | `tools_command_runner`, `tools_clean`, `tools_bootstrap`, `tools_write_key_properties`, `tools_build_android`, `tools_build_config` |
| VS Code | `vscode_extensions`, `vscode_launch`, `vscode_tasks` |
| Melos | `melos_config` |

Templates that take configurable input:

| Template | Parameters beyond names |
|---|---|
| `domain_repo`, `data_source_base`, `data_repo` | `utilsImport`, `addSample`, `taskEither` |
| `rest_data_source` | `utilsImport`, `callAdapter`, `adapterImport` (package URI or relative path), `ignoreErrorLogger`, `addSample`, `taskEither` |
| `get_use_case`, `post_use_case` | `utilsImport`, `importUseCaseBase`, `taskEither` |
| `network_module` | `loggerImport` (package URI or relative path), `registerErrorLogger` |
| `no_auth_dio_method` | `chucker` (pre-1.5.0 network module) |
| `dio_lens_init` | `indent` |
| `retrofit_call_adapter` | `utilsImport`, `className` |
| `retrofit_logger`, `error_model` | `utilsImport` |
| `di_initializer` | `utilsImport`, `utilsPackageModule` |
| `init_service` | `utilsImport`, `localizationImport` |
| `main_app_dart` | `localizationImport` |
| `app_go_router`, `feature_router` | `routerImport` |
| `utils_lib_export`, `clean_router_lib_export` | barrel `prefix` |
| `localization_lib_export` | `generatedFile`, barrel `prefix` |
| `localization_slang_yaml` | slang settings map |
| `string_extension` | `generatedFile`, `translateVar` |
| `safe_cast` | `localizationImport`, `translateVar` |
| `utils_module` | full `moduleName` |
| `feature_navigation` | `optionalContext` |
| `feature_navigation_impl` | `utilsImport`, `contextUtils` |
