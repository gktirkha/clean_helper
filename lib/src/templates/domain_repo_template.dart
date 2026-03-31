String domainRepoTemplate(String className, String name) => '''
import '../entities/${name}_entity.dart';

abstract interface class ${className}Repository {
  Future<${className}Entity> get$className();
  Future<${className}Entity> post$className();
}
''';
