/// An `analysis_options.yaml` that only includes another one, so every
/// project in a workspace shares one set of rules.
String analysisOptionsIncludeTemplate(String path) => 'include: $path\n';
