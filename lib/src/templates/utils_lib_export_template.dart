/// [prefix] leads from the barrel back to `lib/` (see `packageBarrelPrefix`).
String utilsLibExportTemplate([String prefix = '']) =>
    '''
export '${prefix}src/app_logger.dart';
export '${prefix}src/bloc_observer.dart';
export '${prefix}src/context_utils.dart';
export '${prefix}src/debouncer.dart';
export '${prefix}src/di/di_initializer.module.dart';
export '${prefix}src/error_entity.dart';
export '${prefix}src/failure.dart';
export '${prefix}src/functions/get_current_function_name.dart';
export '${prefix}src/functions/list_to_model_list.dart';
export '${prefix}src/functions/safe_cast.dart';
export '${prefix}src/functions/safe_execute.dart';
export '${prefix}src/functions/safe_execute_task.dart';
export '${prefix}src/network/retrofit_call_adapter.dart';
export '${prefix}src/type_definitions.dart';
export '${prefix}src/use_case_base.dart';
''';
