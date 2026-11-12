import 'dart:io';

import '../../templates/analysis_options_include_template.dart';
import 'analysis_options_include.dart';
import 'write_analysis_options.dart';

/// Points the `analysis_options.yaml` of each package in [packageDirs] (paths
/// relative to the current directory, e.g. `packages/my_utils`) at the shared
/// rules: the current project's file, or the workspace root's with
/// `use_root_analysis` in a monorepo app. Existing files follow
/// `overwrite_analysis_options`. Folders without a `pubspec.yaml` are skipped.
void writePackageAnalysisOptions(Iterable<String> packageDirs) {
  for (final dir in packageDirs) {
    if (!File('$dir/pubspec.yaml').existsSync()) continue;
    writeAnalysisOptions(
      '$dir/analysis_options.yaml',
      analysisOptionsIncludeTemplate(analysisOptionsInclude(dir)!),
    );
  }
}
