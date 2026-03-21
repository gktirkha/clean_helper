# Project Structure

```
clean_helpers/
├── bin/
│   ├── clean_helpers.dart       → main entry point (CleanHelpersRunner)
│   ├── init.dart                → legacy: calls runInit() directly
│   ├── add_feature.dart         → legacy: calls addFeature(args) directly
│   ├── add_repo.dart            → legacy: calls addRepo(args) directly
│   ├── add_entity.dart          → legacy: calls addEntity(args) directly
│   └── add_network_module.dart  → calls addNetworkModule() directly
│
├── lib/
│   ├── clean_helpers.dart      # Exports commands only
│   └── src/
│       ├── runner/             # CLI wiring (args + cli_completion)
│       │   ├── clean_helpers_runner.dart   → CleanHelpersRunner (CompletionCommandRunner)
│       │   └── commands/
│       │       ├── init_command.dart               → name: 'init'
│       │       ├── add_feature_command.dart         → name: 'add_feature'
│       │       ├── add_repo_command.dart            → name: 'add_repo'
│       │       ├── add_entity_command.dart          → name: 'add_entity'
│       │       └── add_network_module_command.dart  → name: 'add_network_module'
│       │
│       ├── commands/           # One file = one public entry-point function
│       │   ├── init.dart                → runInit()
│       │   ├── add_feature.dart         → addFeature(List<String>)
│       │   ├── add_repo.dart            → addRepo(List<String>)
│       │   ├── add_entity.dart          → addEntity(List<String>)
│       │   └── add_network_module.dart  → addNetworkModule()
│       │
│       └── functions/
│           ├── shared/                 # Cross-cutting utilities
│           │   ├── pascal_case.dart        → pascalCase(String)
│           │   ├── camel_case.dart         → camelCase(String)
│           │   ├── kebab_case.dart         → kebabCase(String)
│           │   ├── abort.dart              → abort(String) — Never
│           │   ├── run_command.dart        → runCommand(List<String>)
│           │   ├── write_file.dart         → writeFile / overwriteFile
│           │   ├── read_package_name.dart  → readPackageName()
│           │   └── ensure_pubspec.dart     → ensurePubspec()
│           │
│           ├── init/                   # Helpers for runInit()
│           │   ├── create_directories.dart
│           │   ├── generate_flutter_gen_files.dart
│           │   ├── add_flutter_assets_to_pubspec.dart
│           │   ├── generate_localization_files.dart
│           │   ├── generate_core_files.dart
│           │   ├── generate_home_feature.dart
│           │   ├── install_dependencies.dart
│           │   ├── run_slang.dart
│           │   ├── run_dart_format.dart
│           │   ├── run_build_runner.dart
│           │   └── templates/          # String-returning template functions
│           │       ├── analysis_options_template.dart
│           │       ├── main_dart_template.dart
│           │       ├── bootstrap_dart_template.dart
│           │       ├── main_app_dart_template.dart
│           │       ├── app_go_router_template.dart
│           │       ├── router_module_template.dart
│           │       ├── di_container_template.dart
│           │       ├── core_module_template.dart
│           │       ├── di_initializer_template.dart
│           │       ├── router_base_template.dart
│           │       ├── di_keys_template.dart
│           │       └── router_refresh_template.dart
│           │
│           ├── add_network_module/     # Helpers for addNetworkModule()
│           │   ├── install_network_dependencies.dart
│           │   └── (network files generated via init/generate_network_files.dart)
│           │
│           ├── feature/                # Helpers for addFeature()
│           │   ├── create_feature_structure.dart
│           │   ├── generate_feature_routes.dart
│           │   ├── generate_feature_navigation.dart
│           │   ├── generate_feature_navigation_impl.dart
│           │   ├── generate_feature_page.dart
│           │   ├── generate_feature_router.dart
│           │   └── generate_feature_bloc.dart
│           │
│           ├── repo/                   # Helpers for addRepo()
│           │   ├── generate_domain_repo.dart
│           │   └── generate_data_repo.dart
│           │
│           └── entity/                 # Helpers for addEntity()
│               ├── generate_entity_file.dart
│               └── generate_model_file.dart
│
└── pubspec.yaml
```
