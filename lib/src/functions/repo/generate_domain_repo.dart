import 'dart:io';

import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/domain_repo_template.dart';

void generateDomainRepo(
  String dir,
  String name,
  String utilsPackageName, {
  bool addSample = false,
}) {
  final className = pascalCase(name);
  final path = '$dir/${name}_repository.dart';

  writeFile(
    path,
    domainRepoTemplate(className, name, utilsPackageName, addSample: addSample),
  );
  stdout.writeln('  📄 $path');
}
