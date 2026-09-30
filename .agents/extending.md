# Extending clean_helper

Recipes for common changes. Follow `agent_rules.md` throughout.

---

## Add a command

Example: an `add-use-case <feature> <name>` command.

1. **Template** — `lib/src/templates/use_case_template.dart`:

   ```dart
   import '../functions/shared/sort_imports.dart';

   String useCaseTemplate(String className, String utilsImport) => '''
   ${sortImports(["import 'package:fpdart/fpdart.dart';", "import '$utilsImport';"])}

   class ${className}UseCase {}
   ''';
   ```

2. **Helper** — `lib/src/functions/use_case/generate_use_case.dart`, one function:

   ```dart
   import 'dart:io';

   import '../shared/pascal_case.dart';
   import '../shared/write_file.dart';
   import '../../templates/use_case_template.dart';

   void generateUseCase(String feature, String name, String utilsImport) {
     final path = 'lib/features/$feature/domain/use_cases/${name}_use_case.dart';
     writeFile(path, useCaseTemplate(pascalCase(name), utilsImport));
     stdout.writeln('  📄 $path');
   }
   ```

3. **Command** — `lib/src/commands/add_use_case.dart`, one function, starting with `ensurePubspec()`:

   ```dart
   void addUseCase(List<String> args) {
     ensurePubspec();
     if (args.length < 2) abort('Usage: clean-helper add-use-case <feature> <name>');
     final packageName = readPackageName();
     final utilsImport = utilsPackageConfig?.import ??
         'package:${packageName}_utils/${packageName}_utils.dart';
     generateUseCase(args[0], args[1], utilsImport);
     runDartFormat();
     runBuildRunner();
   }
   ```

4. **Runner** — `lib/src/runner/commands/add_use_case_command.dart` (a `Command<void>` with `name`, `description`, flags, and `run()` calling `addUseCase(argResults!.rest)`). Register it with `addCommand(...)` in `CleanHelperRunner`.
5. **Export** the command file from `lib/clean_helper.dart`.
6. **Docs:**
   - a README section and a row in its command table;
   - `.agents/commands/add_use_case.md`;
   - a row in `overview.md`;
   - the new files in `structure.md`;
   - a CHANGELOG entry.

Monorepo support comes free with `ensurePubspec()`, so don't add any app-selection logic.

---

## Add a `clean-helper:` config key

Example: `clean-helper.foo.bar`.

1. Add a global to `functions/shared/package_configs.dart`, with a doc comment saying what null means.
2. Set it in `loadPackageConfigs()` with `readCleanHelperFields(['foo'])['bar']` (or `readPackageConfig(key)` for a `packages.<key>` entry).
3. If the value needs interpreting or validating, add a resolver in the group that uses it, like `repo/uses_task_either.dart`. Resolvers `abort()` on invalid values.
4. The command reads the global or resolver. A missing key must produce exactly today's output.
5. Print the resolved value in `listMonoRepoApps()`.
6. Document the key in the README's Configuration section and table, and in the config table in `overview.md`.

---

## Change a template

1. Put new behaviour behind a named parameter whose default keeps the current output, unless the change is meant to apply to every project.
2. Thread the parameter through the generator function and the command.
3. Keep imports sorted with `sortImports`, and use `camelCase` for identifiers.
4. **Older projects:** if the new output relies on something `init` generates differently now (utils exports, the call adapter, `UseCaseBase`, DI registrations), make it detectable — as `utilsHasRetrofitHelpers()` / `utilsRegistersErrorLogger()` do — or configurable — as `result_type` is. Record it in the README's "Upgrading existing projects" table.
5. Update `architecture.md` if the generated shape changes.

---

## Verify a change

Checks inside clean_helper:

```bash
fvm dart format lib bin
fvm dart analyze                  # must print "No issues found!"
```

End-to-end, in a scratch directory outside the repo, using Flutter 3.47.5 via fvm:

```bash
fvm spawn 3.47.5 create --project-name demo --platforms android demo && cd demo
fvm use 3.47.5 --force
fvm dart run /path/to/clean_helper/bin/clean_helper.dart init --network
fvm dart run /path/to/clean_helper/bin/clean_helper.dart add-feature x
fvm dart run /path/to/clean_helper/bin/clean_helper.dart add-repo x x --add-sample
fvm dart analyze lib packages     # expect no errors or warnings
```

The expected infos are:

- `prefer_initializing_formals` in the generated use cases;
- `prefer_const_constructors` in the model `.g.dart` files;
- Chucker's `navigatorObserver` deprecation.

`test/widget_test.dart` from `flutter create` fails to compile because it references `MyApp`, which `init` removes. Leave it out of analysis.

To compare against the previous release, generate the same project with a `git worktree` of the last tag and `diff -r` the `lib/` trees.

For monorepo behaviour, create a root `pubspec.yaml` with no `lib/`, declaring `mono_repo_apps` (and `packages:` if needed). Move the scratch app under `apps/`, then run commands from the root with `--scope`.

After changing the source, re-run `dart pub global activate --source path .` if you test through the global `clean-helper` command.
