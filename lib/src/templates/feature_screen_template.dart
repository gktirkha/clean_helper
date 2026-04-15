String featureScreenTemplate(String feature, String className) =>
    '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/di_container.dart';
import '../bloc/$feature/${feature}_bloc.dart';
import '../pages/${feature}_page.dart';

class ${className}Screen extends StatelessWidget {
  const ${className}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<${className}Bloc>(
      create: (context) => diContainer(),
      child: ${className}Page(navigation: diContainer()),
    );
  }
}
''';
