import 'dart:io';

/// Whether the local utils package has `ContextUtils`, which `init` generates
/// since 1.5.1. Without it, navigation impls take a required context.
bool utilsHasContextUtils(String utilsPackageName) =>
    File('packages/$utilsPackageName/lib/src/context_utils.dart').existsSync();
