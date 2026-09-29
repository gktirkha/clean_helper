import '../shared/abort.dart';
import '../shared/package_configs.dart';

/// Whether generated repos return `TaskEither<Failure, T>` (the default) or
/// `Future<Either<Failure, T>>` (`clean-helper.result_type: future_either`,
/// for projects whose call adapter still adapts to `Future<Either>`).
bool usesTaskEither() => switch (resultTypeConfig) {
  null || 'task_either' => true,
  'future_either' => false,
  final other => abort(
    'Invalid clean-helper.result_type "$other". '
    'Use task_either or future_either.',
  ),
};
