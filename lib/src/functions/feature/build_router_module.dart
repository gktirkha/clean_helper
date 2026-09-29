import '../../templates/app_router_module_build_template.dart';

/// Sorted so the output doesn't depend on which command last wrote the file.
String buildRouterModule(List<String> features) =>
    appRouterModuleBuildTemplate([...features]..sort());
