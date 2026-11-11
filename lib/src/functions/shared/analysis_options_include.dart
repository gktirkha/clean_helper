import 'package_configs.dart';

/// The `include:` path for the `analysis_options.yaml` of the project at
/// [dir] (relative to the current directory; `''` for the current project),
/// or null when that file should hold the full rules itself.
///
/// - Packages (`dir` non-empty) include the current project's file, e.g.
///   `packages/x` → `../../analysis_options.yaml`.
/// - With [useRootAnalysisConfig] inside a monorepo app, both the app and its
///   packages include the workspace root's file instead.
String? analysisOptionsInclude(String dir) {
  int depth(String path) =>
      path.isEmpty ? 0 : path.split('/').where((s) => s.isNotEmpty).length;

  final upToRoot = useRootAnalysisConfig ? depth(monoRepoAppPath ?? '') : 0;
  final up = depth(dir) + upToRoot;
  return up == 0 ? null : '${'../' * up}analysis_options.yaml';
}
