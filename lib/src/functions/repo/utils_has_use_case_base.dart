import 'dart:io';

/// Whether the local utils package has `UseCaseBase`, which `init` generates
/// there since 1.7.0. Older projects have it in
/// `lib/core/domain/use_cases/use_case_base.dart` instead.
bool utilsHasUseCaseBase(String utilsPackageName) =>
    File('packages/$utilsPackageName/lib/src/use_case_base.dart').existsSync();
