String featurePageTemplate(String feature, String className) =>
    '''
import 'package:flutter/material.dart';

import '../../router/${feature}_navigation.dart';

class ${className}Page extends StatelessWidget {
  const ${className}Page({super.key, required this.navigation});
  final ${className}Navigation navigation;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('$className Page')));
  }
}
''';
