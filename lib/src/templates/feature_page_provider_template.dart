import '../functions/shared/pascal_case.dart';

/// [bloc] is the feature's bloc name (snake_case), or null when the feature
/// was generated without one.
String featurePageProviderTemplate(
  String feature,
  String className, {
  String? bloc,
}) {
  final page = '${className}Page(navigation: diContainer())';
  if (bloc == null) {
    return '''
import 'package:material_ui/material_ui.dart';

import '../../../../app/di/di_container.dart';
import '../pages/${feature}_page.dart';

class ${className}PageProvider extends StatelessWidget {
  const ${className}PageProvider({super.key});

  @override
  Widget build(BuildContext context) => $page;
}
''';
  }
  final blocClass = '${pascalCase(bloc)}Bloc';
  return '''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/di/di_container.dart';
import '../bloc/$bloc/${bloc}_bloc.dart';
import '../pages/${feature}_page.dart';

class ${className}PageProvider extends StatelessWidget {
  const ${className}PageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<$blocClass>(
      create: (context) => diContainer(),
      child: $page,
    );
  }
}
''';
}
