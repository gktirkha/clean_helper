import '../../templates/app_router_module_build_template.dart';
import '../shared/read_package_name.dart';

/// Content of the app's router module for [features], sorted so the output
/// doesn't depend on which command last wrote the file.
String buildRouterModule(List<String> features) =>
    appRouterModuleBuildTemplate(readPackageName(), [...features]..sort());
