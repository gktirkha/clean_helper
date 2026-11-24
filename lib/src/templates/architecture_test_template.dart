/// `test/architecture_test.dart`: checks the rules in `.agents/rules.md`
/// (feature independence, clean layers, shared modules, package layering,
/// blocs and data classes) over the app and every workspace package.
///
/// [appName] is the app's package name, [foundationDir] the foundation
/// folder and [themePackage] the theme package, whose imports count as UI.
String architectureTestTemplate(
  String appName,
  String foundationDir,
  String themePackage,
) => _template
    .replaceAll('__APP__', appName)
    .replaceAll('__FOUNDATION__', foundationDir)
    .replaceAll('__THEME__', themePackage);

const _template = r"""
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

/// Checks the rules in `.agents/rules.md`. Change a rule there and here
/// together.
void main() {
  // ── Shared modules and the modules each may import ──────────────────
  //
  // Adding a module, or an edge, is a design decision.
  const sharedModules = <String, Set<String>>{};

  const bannedModuleNames = {
    'base', 'common', 'components', 'core', 'general', 'helper', 'helpers', //
    'misc', 'services', 'shared', 'util', 'utils', 'widgets',
  };
  const minFeatureUsers = 2;
  const foundationDir = '__FOUNDATION__';
  const layers = {'presentation', 'domain', 'data'};
  final uiImport = RegExp(
    r'''['"]package:(material_ui|flutter_bloc|__THEME__|flutter/(material|widgets|cupertino))''',
  );

  // ── Source scanning ─────────────────────────────────────────────────

  final importPattern = RegExp(r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''');
  final generated = RegExp(r'\.(g|freezed|config|module)\.dart$');

  List<File> dartFiles(String dir) => Directory(dir).existsSync()
      ? Directory(dir)
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))
            .where((f) => !generated.hasMatch(f.path))
            .where((f) => !p.split(f.path).contains('generated'))
            .toList()
      : [];

  void expectNone(List<String> violations) =>
      expect(violations, isEmpty, reason: violations.join('\n'));

  // ── Workspace ───────────────────────────────────────────────────────

  String? pubspecValue(String dir, String key) {
    final file = File(p.join(dir, 'pubspec.yaml'));
    if (!file.existsSync()) return null;
    for (final line in file.readAsLinesSync()) {
      if (line.startsWith('$key:')) {
        return line.substring(key.length + 1).trim();
      }
    }
    return null;
  }

  /// Entries of a top-level pubspec section, e.g. `workspace` or
  /// `dependencies`.
  List<String> pubspecSection(String dir, String section) {
    final file = File(p.join(dir, 'pubspec.yaml'));
    if (!file.existsSync()) return [];
    final entries = <String>[];
    var inside = false;
    for (final line in file.readAsLinesSync()) {
      if (line.trim().isEmpty || line.trimLeft().startsWith('#')) continue;
      if (!line.startsWith(' ')) {
        inside = line.startsWith('$section:');
        continue;
      }
      if (!inside) continue;
      final item = RegExp(r'^  (?:- )?([\w./-]+)').firstMatch(line);
      if (item != null) entries.add(item.group(1)!);
    }
    return entries;
  }

  // The nearest pubspec with a `workspace:` section, else this app alone.
  var root = Directory.current.path;
  for (var dir = Directory.current; ; dir = dir.parent) {
    if (pubspecSection(dir.path, 'workspace').isNotEmpty) {
      root = dir.path;
      break;
    }
    if (dir.parent.path == dir.path) break;
  }

  /// Workspace packages other than this app: name → directory.
  final packages = <String, String>{
    for (final entry in pubspecSection(root, 'workspace'))
      if (pubspecValue(p.join(root, entry), 'name') case final name?)
        if (name != '__APP__') name: p.relative(p.join(root, entry)),
  };

  /// `lib/` of this app and of every workspace package, by package name.
  final libs = {
    '__APP__': 'lib',
    for (final MapEntry(:key, :value) in packages.entries)
      key: p.join(value, 'lib'),
  };

  /// The file an import points at, or null outside the workspace.
  String? resolve(String uri, String fromFile) {
    if (uri.startsWith('package:')) {
      final rest = uri.substring(8);
      final slash = rest.indexOf('/');
      final lib = libs[rest.substring(0, slash)];
      return lib == null ? null : p.join(lib, rest.substring(slash + 1));
    }
    if (uri.contains(':')) return null;
    return p.normalize(p.join(p.dirname(fromFile), uri));
  }

  /// Every workspace import as `(file, line number, line, target)`.
  Iterable<(String, int, String, String)> importsOf(String dir) sync* {
    for (final file in dartFiles(dir)) {
      for (final (i, line) in file.readAsLinesSync().indexed) {
        final match = importPattern.firstMatch(line);
        if (match == null) continue;
        final target = resolve(match.group(1)!, file.path);
        if (target != null) yield (file.path, i + 1, line, target);
      }
    }
  }

  /// `(area, name)` of a path under the app's `lib/` (or `test/`), e.g.
  /// `('shared', 'cart')`; null outside it.
  (String, String?)? placeOf(String path, [String from = 'lib']) {
    if (!p.isWithin(from, path)) return null;
    final parts = p.split(p.relative(path, from: from));
    return (parts.first, parts.length > 2 ? parts[1] : null);
  }

  /// `(layer, module root)` of a path, from its first layer folder.
  (String, String)? layerOf(String path) {
    final parts = p.split(p.normalize(path));
    for (final (i, part) in parts.indexed) {
      if (layers.contains(part)) return (part, p.joinAll(parts.take(i)));
    }
    return null;
  }

  // ── Features are independent ────────────────────────────────────────

  for (final from in ['lib', 'test']) {
    test('$from/features/* do not import other features', () {
      final violations = <String>[];
      for (final (file, n, _, target)
          in importsOf(p.join(from, 'features'))) {
        final own = placeOf(file, from)?.$2;
        if (placeOf(target) case ('features', final other)
            when other != own) {
          violations.add('$file:$n imports feature "$other"');
        }
      }
      expectNone(violations);
    });
  }

  test('core imports neither shared, features nor app', () {
    expectNone([
      for (final (file, n, _, target) in importsOf('lib/core'))
        if (const {'shared', 'features', 'app'}.contains(placeOf(target)?.$1))
          '$file:$n imports $target',
    ]);
  });

  test('shared imports neither features nor app', () {
    expectNone([
      for (final (file, n, _, target) in importsOf('lib/shared'))
        if (const {'features', 'app'}.contains(placeOf(target)?.$1))
          '$file:$n imports $target',
    ]);
  });

  // ── Clean layers ────────────────────────────────────────────────────

  test('presentation and data import only domain; domain imports no UI', () {
    const allowed = {
      'domain': {'domain'},
      'presentation': {'presentation', 'domain'},
      'data': {'data', 'domain'},
    };
    final violations = <String>[];
    for (final lib in libs.values) {
      for (final file in dartFiles(lib)) {
        final (layer, module) = layerOf(file.path) ?? ('', '');
        if (layer.isEmpty) continue;
        for (final (i, line) in file.readAsLinesSync().indexed) {
          final match = importPattern.firstMatch(line);
          if (match == null) continue;
          if (layer == 'domain' && uiImport.hasMatch(line)) {
            violations.add('${file.path}:${i + 1}: domain imports UI');
            continue;
          }
          final target = resolve(match.group(1)!, file.path);
          final (targetLayer, targetModule) =
              target == null ? ('', '') : layerOf(target) ?? ('', '');
          if (targetLayer.isEmpty) continue;
          // Across modules only domain, or shared presentation widgets.
          final ok = targetModule == module
              ? allowed[layer]!.contains(targetLayer)
              : targetLayer == 'domain' ||
                    (layer == 'presentation' && targetLayer == 'presentation');
          if (!ok) {
            violations.add(
              '${file.path}:${i + 1}: $layer imports $targetLayer '
              '(${match.group(1)})',
            );
          }
        }
      }
    }
    expectNone(violations);
  });

  test('data files are grouped in sub-folders of data/', () {
    expectNone([
      for (final lib in libs.values)
        for (final file in dartFiles(lib))
          if (p.split(p.normalize(file.path)) case final parts
              when parts.contains('data') &&
                  parts.indexOf('data') == parts.length - 2)
            '${file.path}: move it into a data/ sub-folder '
                '(datasources/, repositories/, models/, constants/)',
    ]);
  });

  // ── Shared modules ──────────────────────────────────────────────────

  test('shared modules are declared and named after a business area', () {
    final violations = <String>[
      for (final name in sharedModules.keys)
        if (bannedModuleNames.contains(name))
          '"$name" is a junk-drawer name; name the business area instead',
    ];
    final dir = Directory('lib/shared');
    if (dir.existsSync()) {
      for (final entity in dir.listSync()) {
        final name = p.basename(entity.path);
        if (entity is File && name != 'README.md') {
          violations.add('${entity.path}: no loose files; put it in a module');
        } else if (entity is Directory && !sharedModules.containsKey(name)) {
          violations.add('lib/shared/$name is not declared in sharedModules');
        }
      }
    }
    expectNone(violations);
  });

  test('shared code sits in data/, domain/ or presentation/', () {
    expectNone([
      for (final file in dartFiles('lib/shared'))
        if (p.split(p.relative(file.path, from: 'lib/shared'))
            case [_, final layer, _, ...] when layers.contains(layer))
          null
        else
          '${file.path}: use lib/shared/<module>/{data,domain,presentation}/',
    ].nonNulls.toList());
  });

  test('shared modules only import the modules they declare', () {
    final violations = <String>[];
    for (final (file, n, _, target) in importsOf('lib/shared')) {
      final own = placeOf(file)?.$2;
      if (placeOf(target) case ('shared', final other?) when other != own) {
        if (!(sharedModules[own]?.contains(other) ?? false)) {
          violations.add('$file:$n: "$own" imports undeclared "$other"');
        }
      }
    }
    expectNone(violations);
  });

  test('declared shared dependencies have no cycles', () {
    final done = <String>{};
    List<String>? cycleFrom(String module, List<String> path) {
      if (path.contains(module)) return [...path, module];
      if (done.contains(module)) return null;
      for (final dep in sharedModules[module] ?? const <String>{}) {
        final cycle = cycleFrom(dep, [...path, module]);
        if (cycle != null) return cycle;
      }
      done.add(module);
      return null;
    }

    for (final module in sharedModules.keys) {
      final cycle = cycleFrom(module, []);
      expect(cycle, isNull, reason: 'cycle: ${cycle?.join(' → ')}');
    }
  });

  test('every shared module is used by at least $minFeatureUsers features', () {
    final users = {for (final m in sharedModules.keys) m: <String>{}};
    for (final (file, _, _, target) in importsOf('lib/features')) {
      final feature = placeOf(file)?.$2;
      if (placeOf(target) case ('shared', final module?) when feature != null) {
        users[module]?.add(feature);
      }
    }
    expectNone([
      for (final MapEntry(key: module, value: features) in users.entries)
        if (features.length < minFeatureUsers)
          '"$module" is used by '
              '${features.isEmpty ? 'no feature' : features.join(', ')}; '
              'move it into that feature',
    ]);
  });

  // ── Packages ────────────────────────────────────────────────────────

  test('foundation depends on no workspace package, core only on foundation',
      () {
    final groups = {
      for (final MapEntry(:key, :value) in packages.entries)
        key: p.split(p.relative(value, from: root)).first,
    };
    final apps = {
      '__APP__',
      for (final MapEntry(:key, :value) in packages.entries)
        if (File(p.join(value, 'lib/main.dart')).existsSync()) key,
    };
    final violations = <String>[];
    for (final (name, dir) in [
      ('__APP__', '.'),
      for (final MapEntry(:key, :value) in packages.entries) (key, value),
    ]) {
      for (final dep in [
        ...pubspecSection(dir, 'dependencies'),
        ...pubspecSection(dir, 'dev_dependencies'),
      ]) {
        if (!packages.containsKey(dep) && dep != '__APP__') continue;
        final ok = switch (groups[name]) {
          foundationDir => false,
          'core' => groups[dep] == foundationDir,
          _ => !apps.contains(dep),
        };
        if (!ok) violations.add('$name (${groups[name]}) depends on $dep');
      }
    }
    expectNone(violations);
  });

  // ── Blocs and data classes ──────────────────────────────────────────

  test('state holders are blocs, not cubits', () {
    final cubit = RegExp(r'extends\s+(Hydrated)?Cubit<');
    expectNone([
      for (final file in dartFiles('lib'))
        for (final (i, line) in file.readAsLinesSync().indexed)
          if (cubit.hasMatch(line))
            '${file.path}:${i + 1}: use a Bloc with freezed events',
    ]);
  });

  test('blocs handle their event union in one on<Event> with when', () {
    final perSubclass = RegExp(r'\bon<_\w+>\(');
    expectNone([
      for (final file in dartFiles('lib'))
        for (final (i, line) in file.readAsLinesSync().indexed)
          if (perSubclass.hasMatch(line))
            '${file.path}:${i + 1}: use on<Event>((e, emit) => e.when(…))',
    ]);
  });

  test('value types use freezed, not hand-written equality', () {
    final handWritten = RegExp(r'^\s*(@immutable\b|bool operator ==)');
    expectNone([
      for (final file in dartFiles('lib'))
        for (final (i, line) in file.readAsLinesSync().indexed)
          if (handWritten.hasMatch(line))
            '${file.path}:${i + 1}: use a @freezed class instead',
    ]);
  });
}
""";
