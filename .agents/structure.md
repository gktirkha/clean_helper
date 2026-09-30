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
| `package_configs.dart` | `PackageConfig` typedef; `utilsPackageConfig`, `networkPackageConfig`, `retrofitCallAdapterConfig`, `resultTypeConfig` | Config globals |
| `read_clean_helper_fields.dart` | `readCleanHelperFields(path)` | Scalar children of `clean-helper.<path…>` |
| `read_package_config.dart` | `readPackageConfig(key)` | `packages.<key>` → `PackageConfig?` |
| `read_mono_repo_apps.dart` | `readMonoRepoApps()` | `mono_repo_apps` list |
| `read_package_name.dart` | `readPackageName()` | `name:` from the current pubspec |
| `resolve_mono_repo_project.dart` | `resolveMonoRepoProject()` | No `lib/`? Select an app and `chdir` into it |
| `prompt_project_selection.dart` | `promptProjectSelection(apps, {title})` | Numbered stdin prompt |
| `scope_option.dart` | `resolveScope` | `--scope` value |
| `check_version_mismatch.dart` | `checkVersionMismatch()` | Warn if `clean-helper.version` ≠ `toolVersion` |
| `tool_version.dart` | `toolVersion` | Must equal pubspec `version:` |
| `write_file.dart` | `writeFile`, `overwriteFile` | The only way to write target files |
| `insert_after_last_import.dart` | `insertAfterLastImport(content, line)` | Patch helper |
| `run_command.dart` | `runCommand(cmd, {workingDirectory})` | Run a process, abort on failure |
| `run_command_streamed.dart` | `runCommandStreamed(cmd)` | Same, streaming output |
| `fvm_exec.dart` | `fvmExec(exe)` | `['fvm', exe]` or `[exe]` |
| `fvm_use.dart` | `fvmUse()` (async) | Interactive `fvm use` |

### `init/` — `runInit()` and helpers reused by other commands

| File | Function |
|---|---|
| `generate_analysis_options.dart` | `generateAnalysisOptions()` |
| `run_flutter_pub_get.dart` | `runFlutterPubGet()` |
| `create_directories.dart` | `createDirectories()` — the only place allowed to call `Directory.createSync` |
| `generate_localization_files.dart` | `generateLocalizationFiles()` — no-op |
| `generate_flutter_gen_files.dart` | `generateFlutterGenFiles()` |
| `generate_clean_router_package.dart` | `generateCleanRouterPackage()` |
| `generate_localization_package.dart` | `generateLocalizationPackage(localizationPackageName)` |
| `generate_utils_package.dart` | `generateUtilsPackage(utilsPackageName, localizationPackageName)` |
| `patch_package_pubspec.dart` | `patchPackagePubspec(packagePath, pubspecTail)` |
| `add_clean_router_workspace.dart` | `addCleanRouterWorkspace(utilsPackageName, localizationPackageName)` |
| `generate_core_files.dart` | `generateCoreFiles(packageName, utilsPackageName)` |
| `generate_utils_files.dart` | `generateUtilsFiles(utilsPackageName)` — `use_case_base.dart` |
| `generate_home_feature.dart` | `generateHomeFeature(packageName, {withDi})` |
| `generate_tools_files.dart` | `generateToolsFiles({overwrite})` |
| `install_dependencies.dart` | `installDependencies(utilsPackageName, localizationPackageName)` |
| `update_gitignore.dart` | `updateGitignore()` |
| `add_flutter_assets_to_pubspec.dart` | `addFlutterAssetsToPubSpec()` |
| `add_chucker_dependency.dart` | `addChuckerDependency()` |
| `generate_network_files.dart` | `generateNetworkFiles(utilsImport, {registerErrorLogger, retrofitHelpersInUtils})` |
| `generate_retrofit_call_adapter.dart` | `generateRetrofitCallAdapter(utilsImport)` → `lib/core/network/utils/` |
| `generate_retrofit_logger.dart` | `generateRetrofitLogger(utilsImport)` → `lib/core/network/utils/` |
| `run_slang.dart` | `runSlang(localizationPackageName)` |
| `run_build_runner.dart` | `runBuildRunner({workingDirectory})` |
| `run_dart_format.dart` | `runDartFormat()` |
| `sort_pubspec_deps.dart` | `sortPubspecDeps([path])` |
| `write_tool_version.dart` | `writeToolVersion()` |

### `feature/` — `add-feature`

`create_feature_structure.dart` → `createFeatureStructure(basePath, feature, {withDi})` calls the `generateFeature*` helpers: `routes`, `navigation`, `navigation_impl`, `page`, `page_provider`, `router`, `bloc`, `module`. `patch_router_module.dart` → `patchRouterModule(feature)`. `build_router_module.dart` → `buildRouterModule(features)`, which sorts features and is the single source of `app_router_module.dart` content.

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
| `warn_missing_rest_dependencies.dart` | `warnMissingRestDependencies()` |

### Other groups

| Folder | Files → functions |
|---|---|
| `entity/` | `generateEntityFile(dir, name)`, `generateModelFile(dir, name, entityImport)` |
| `add_network_module/` | `installNetworkDependencies()`, `patchAppGoRouter()`, `utilsRegistersErrorLogger(utils)`, `utilsHasRetrofitHelpers(utils)` |
| `auth_interceptor/` | `generateAuthInterceptor()`, `patchDiKeys()`, `patchNetworkModule()` |
| `remove_feature/` | `deleteFeatureFiles(feature)`, `unpatchRouterModule(feature)` |
| `build_runner/` | `runBuildRunnerBuild()`, `runBuildRunnerClean()` |
| `generate_localizations/` | `runGenerateLocalizations()` |
| `vscode_config/` | `generateVscodeExtensions()`, `generateVscodeLaunch()`, `generateVscodeTasks()` |

---

## `lib/src/templates/`

Each file is `<name>_template.dart` → `<name>Template(...)`.

| Area | Templates |
|---|---|
| App skeleton | `main_dart`, `main_app_dart`, `bootstrap_dart`, `di_container`, `di_initializer`, `di_keys`, `app_module`, `core_module`, `app_go_router`, `app_go_router_redirect`, `app_router_module`, `app_router_module_build` |
| Feature | `feature_routes`, `feature_navigation`, `feature_navigation_impl`, `feature_router`, `feature_page`, `feature_page_provider`, `feature_bloc`, `feature_event`, `feature_state`, `feature_module` |
| Repo | `domain_repo`, `data_source_base`, `data_repo`, `rest_data_source`, `feature_api_paths`, `request_model`, `response_model`, `get_use_case`, `post_use_case`, `get_use_case_params`, `post_use_case_params`, `use_case_base` |
| Entity | `entity`, `model` |
| Network | `network_module`, `core_api_paths`, `error_interceptor`, `error_model`, `retrofit_call_adapter`, `retrofit_logger`, `auth_interceptor`, `di_keys_no_auth`, `no_auth_dio_method` |
| Utils package | `utils_lib_export`, `utils_pubspec_tail`, `utils_module`, `utils_di_initializer`, `app_logger`, `app_bloc_observer`, `debounce`, `error_entity`, `failure`, `type_definitions`, `get_current_function_name`, `list_to_model_list`, `safe_cast`, `safe_execute`, `safe_execute_task` |
| Localization package | `localization_lib_export`, `localization_pubspec_tail`, `localization_slang_yaml`, `string_extension`, `en_locale`, `slang_yaml` |
| clean_router package | `clean_router_base`, `clean_router_refresh`, `clean_router_lib_export`, `clean_router_pubspec_tail` |
| Project config | `analysis_options`, `build_yaml`, `colors_xml`, `gitignore` |
| Tools | `tools_command_runner`, `tools_clean`, `tools_bootstrap`, `tools_write_key_properties`, `tools_build_android`, `tools_build_config` |
| VS Code | `vscode_extensions`, `vscode_launch`, `vscode_tasks` |

Templates that take configurable input:

| Template | Parameters beyond names |
|---|---|
| `domain_repo`, `data_source_base`, `data_repo` | `utilsImport`, `addSample`, `taskEither` |
| `rest_data_source` | `utilsImport`, `callAdapter`, `adapterImport` (package URI or relative path), `ignoreErrorLogger`, `addSample`, `taskEither` |
| `get_use_case`, `post_use_case` | `utilsImport`, `importUseCaseBase`, `taskEither` |
| `network_module` | `loggerImport` (package URI or relative path), `registerErrorLogger` |
| `retrofit_call_adapter`, `retrofit_logger`, `error_model` | `utilsImport` |
| `use_case_base`, `di_initializer` | `utilsPackageName` |
