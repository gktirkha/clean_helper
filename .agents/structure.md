# Project Structure

```
clean_helper/
├── bin/
│   ├── clean_helper.dart            → main entry point (CleanHelperRunner)
│   ├── init.dart                    → legacy: calls runInit() directly
│   ├── add_feature.dart             → legacy: calls addFeature(args) directly
│   ├── add_repo.dart                → legacy: calls addRepo(args) directly
│   ├── add_entity.dart              → legacy: calls addEntity(args) directly
│   ├── add_network_module.dart      → legacy: calls addNetworkModule() directly
│   ├── add_auth_interceptor.dart    → legacy: calls addAuthInterceptor() directly
│   ├── build_runner.dart            → legacy: calls runBuildRunnerCommand(args) directly
│   ├── remove_feature.dart          → legacy: calls removeFeature(args) directly
│   ├── regenerate_router.dart       → legacy: calls regenerateRouter() directly
│   ├── generate_localizations.dart  → legacy: calls runGenerateLocalizationsCommand(args)
│   └── generate_tools.dart          → legacy: calls generateTools(args) directly
│
├── lib/
│   ├── clean_helper.dart      # Exports commands only
│   └── src/
│       ├── runner/             # CLI wiring (args + cli_completion)
│       │   ├── clean_helper_runner.dart              → CleanHelperRunner (CompletionCommandRunner)
│       │   └── commands/
│       │       ├── init_command.dart                      → name: 'init'
│       │       ├── add_feature_command.dart               → name: 'add_feature'
│       │       ├── add_repo_command.dart                  → name: 'add_repo'
│       │       ├── add_entity_command.dart                → name: 'add_entity'
│       │       ├── add_network_module_command.dart        → name: 'add_network_module'
│       │       ├── add_auth_interceptor_command.dart      → name: 'add_auth_interceptor'
│       │       ├── add_vscode_config_command.dart         → name: 'add_vscode_config'
│       │       ├── build_runner_command.dart              → name: 'build_runner'
│       │       ├── remove_feature_command.dart            → name: 'remove_feature'
│       │       ├── regenerate_router_command.dart         → name: 'regenerate_router'
│       │       ├── generate_localizations_command.dart    → name: 'generate_localizations'
│       │       └── generate_tools_command.dart            → name: 'generate_tools'
│       │
│       ├── commands/           # One file = one public entry-point function
│       │   ├── init.dart                    → runInit() [async]
│       │   ├── add_feature.dart             → addFeature(List<String>)
│       │   ├── add_repo.dart                → addRepo(List<String>)
│       │   ├── add_entity.dart              → addEntity(List<String>)
│       │   ├── add_network_module.dart      → addNetworkModule()
│       │   ├── add_auth_interceptor.dart    → addAuthInterceptor()
│       │   ├── add_vscode_config.dart       → addVscodeConfig()
│       │   ├── bootstrap.dart               → runBootstrapCommand() [async]
│       │   ├── build_runner.dart            → runBuildRunnerCommand(List<String>)
│       │   ├── remove_feature.dart          → removeFeature(List<String>)
│       │   ├── regenerate_router.dart       → regenerateRouter()
│       │   ├── generate_localizations.dart  → runGenerateLocalizationsCommand(List<String>)
│       │   └── generate_tools.dart          → generateTools({bool overwrite})
│       │
│       ├── templates/          # Generated file content — one template function per file
│       │   ├── analysis_options_template.dart
│       │   ├── app_go_router_template.dart
│       │   ├── app_go_router_redirect_template.dart
│       │   ├── app_module_template.dart
│       │   ├── app_router_module_template.dart         ← appRouterModuleTemplate()
│       │   ├── app_router_module_build_template.dart   ← appRouterModuleBuildTemplate()
│       │   ├── app_logger_template.dart
│       │   ├── auth_interceptor_template.dart
│       │   ├── bootstrap_dart_template.dart
│       │   ├── build_yaml_template.dart
│       │   ├── clean_router_base_template.dart
│       │   ├── clean_router_lib_export_template.dart
│       │   ├── clean_router_pubspec_tail_template.dart
│       │   ├── clean_router_refresh_template.dart
│       │   ├── colors_xml_template.dart
│       │   ├── core_api_paths_template.dart
│       │   ├── core_module_template.dart
│       │   ├── data_repo_template.dart
│       │   ├── data_source_base_template.dart
│       │   ├── debounce_template.dart
│       │   ├── di_container_template.dart
│       │   ├── di_initializer_template.dart
│       │   ├── di_keys_no_auth_template.dart
│       │   ├── di_keys_template.dart
│       │   ├── domain_repo_template.dart
│       │   ├── en_locale_template.dart
│       │   ├── entity_template.dart
│       │   ├── error_entity_template.dart
│       │   ├── error_interceptor_template.dart
│       │   ├── error_model_template.dart
│       │   ├── failure_template.dart
│       │   ├── feature_api_paths_template.dart
│       │   ├── feature_bloc_template.dart
│       │   ├── feature_event_template.dart
│       │   ├── feature_module_template.dart
│       │   ├── feature_navigation_impl_template.dart
│       │   ├── feature_navigation_template.dart
│       │   ├── feature_page_template.dart
│       │   ├── feature_router_template.dart
│       │   ├── feature_routes_template.dart
│       │   ├── feature_screen_template.dart
│       │   ├── feature_state_template.dart
│       │   ├── gitignore_template.dart
│       │   ├── get_current_function_name_template.dart
│       │   ├── list_to_model_list_template.dart
│       │   ├── main_app_dart_template.dart
│       │   ├── main_dart_template.dart
│       │   ├── model_template.dart
│       │   ├── network_module_template.dart
│       │   ├── no_auth_dio_method_template.dart
│       │   ├── request_model_template.dart
│       │   ├── response_model_template.dart
│       │   ├── rest_data_source_template.dart
│       │   ├── safe_cast_template.dart
│       │   ├── safe_execute_template.dart
│       │   ├── slang_yaml_template.dart
│       │   ├── string_extension_template.dart
│       │   ├── tools_bootstrap_template.dart
│       │   ├── tools_build_android_template.dart
│       │   ├── tools_build_config_template.dart
│       │   ├── tools_clean_template.dart
│       │   ├── tools_command_runner_template.dart
│       │   ├── tools_write_key_properties_template.dart
│       │   ├── type_definitions_template.dart
│       │   ├── use_case_base_template.dart
│       │   ├── vscode_extensions_template.dart
│       │   ├── vscode_launch_template.dart
│       │   └── vscode_tasks_template.dart
│       │
│       └── functions/
│           ├── shared/                 # Cross-cutting utilities
│           │   ├── abort.dart                        → abort(String) — Never
│           │   ├── camel_case.dart                   → camelCase(String)
│           │   ├── ensure_pubspec.dart                → ensurePubspec() — checks pubspec + calls resolveMonoRepoProject()
│           │   ├── fvm_exec.dart                     → fvmExec(String exe) — returns ['fvm', exe] or [exe]
│           │   ├── fvm_use.dart                      → fvmUse() [async] — runs 'fvm use' interactively if fvm exists
│           │   ├── insert_after_last_import.dart      → insertAfterLastImport()
│           │   ├── kebab_case.dart                   → kebabCase(String)
│           │   ├── pascal_case.dart                  → pascalCase(String)
│           │   ├── prompt_project_selection.dart      → promptProjectSelection(List<String>) — interactive app picker
│           │   ├── read_mono_repo_apps.dart           → readMonoRepoApps() — parses clean-helper.mono_repo_apps from pubspec
│           │   ├── read_package_name.dart             → readPackageName()
│           │   ├── resolve_mono_repo_project.dart     → resolveMonoRepoProject() — detects monorepo + sets Directory.current
│           │   ├── run_command.dart                  → runCommand(List<String>)
│           │   ├── run_command_streamed.dart          → runCommandStreamed(List<String>)
│           │   └── write_file.dart                   → writeFile / overwriteFile
│           │
│           ├── init/                   # Helpers for runInit()
│           │   ├── add_chucker_dependency.dart
│           │   ├── add_clean_router_workspace.dart
│           │   ├── add_flutter_assets_to_pubspec.dart
│           │   ├── create_directories.dart
│           │   ├── generate_clean_router_package.dart
│           │   ├── generate_core_files.dart
│           │   ├── generate_flutter_gen_files.dart
│           │   ├── generate_home_feature.dart
│           │   ├── generate_localization_files.dart
│           │   ├── generate_network_files.dart
│           │   ├── generate_tools_files.dart
│           │   ├── generate_utils_files.dart
│           │   ├── install_dependencies.dart
│           │   ├── run_build_runner.dart
│           │   ├── run_dart_format.dart
│           │   ├── run_flutter_pub_get.dart
│           │   ├── run_slang.dart
│           │   └── update_gitignore.dart
│           │
│           ├── feature/                # Helpers for addFeature()
│           │   ├── build_router_module.dart          → buildRouterModule(List<String>)
│           │   ├── create_feature_structure.dart
│           │   ├── generate_feature_bloc.dart
│           │   ├── generate_feature_module.dart
│           │   ├── generate_feature_navigation.dart
│           │   ├── generate_feature_navigation_impl.dart
│           │   ├── generate_feature_page.dart
│           │   ├── generate_feature_router.dart
│           │   ├── generate_feature_routes.dart
│           │   ├── generate_feature_screen.dart
│           │   └── patch_router_module.dart
│           │
│           ├── repo/                   # Helpers for addRepo()
│           │   ├── generate_api_paths.dart
│           │   ├── generate_data_repo.dart
│           │   ├── generate_data_source_base.dart
│           │   ├── generate_domain_repo.dart
│           │   ├── generate_request_model.dart
│           │   ├── generate_response_model.dart
│           │   └── generate_rest_data_source.dart
│           │
│           ├── entity/                 # Helpers for addEntity()
│           │   ├── generate_entity_file.dart
│           │   └── generate_model_file.dart
│           │
│           ├── auth_interceptor/       # Helpers for addAuthInterceptor()
│           │   ├── generate_auth_interceptor.dart
│           │   ├── patch_di_keys.dart
│           │   └── patch_network_module.dart
│           │
│           ├── add_network_module/     # Helpers for addNetworkModule()
│           │   ├── install_network_dependencies.dart
│           │   └── patch_app_go_router.dart
│           │
│           ├── remove_feature/         # Helpers for removeFeature()
│           │   ├── delete_feature_files.dart
│           │   └── unpatch_router_module.dart
│           │
│           ├── build_runner/           # Helpers for runBuildRunnerCommand()
│           │   ├── run_build_runner_build.dart
│           │   └── run_build_runner_clean.dart
│           │
│           ├── generate_localizations/
│           │   └── run_generate_localizations.dart
│           │
│           └── vscode_config/          # Helpers for addVscodeConfig()
│               ├── generate_vscode_extensions.dart
│               ├── generate_vscode_launch.dart
│               └── generate_vscode_tasks.dart
│
└── pubspec.yaml
```
