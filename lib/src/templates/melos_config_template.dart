/// [version] pins the clean_helper the bootstrap hook activates from pub.dev.
/// Raw strings keep the shell syntax (`$(...)`, `$OSS_IGNORE`) intact.
String melosConfigTemplate(String version) =>
    r'''
melos:
  command:
    bootstrap:
      hooks:
        pre: |
          melos use_fvm
          dart pub global activate clean_helper '''
    '$version\n'
    r'''          dart pub global activate slang
          dart pub global activate flutter_gen
          dart pub global activate dependency_validator
        post: |
          mkdir -p temp
          melos localize
          melos autogen
          melos generate_license

    clean:
      hooks:
        post: |
          git clean -fdX
          melos use_fvm

  scripts:
    autogen:
      run: melos exec --order-dependents -- "dart run build_runner build"
      packageFilters:
        dependsOn:
          - "build_runner"
      description: Run Build Runner

    autogen_watch:
      run: melos exec "dart run build_runner watch"
      packageFilters:
        dependsOn:
          - "build_runner"
      description: Run Build Runner watch

    dependency_validator:
      run: melos exec -c 1 -- "dependency_validator"
      description: Run `dependency_validator` checks on all packages.

    fluttergen:
      run: melos exec -- "fluttergen"
      packageFilters:
        dependsOn:
          - "flutter_gen_runner"
      description: Run fluttergen

    generate_license:
      run: |
        OSS_IGNORE="flutter,$(melos list | paste -sd, -)"
        echo "Ignoring workspace packages: $OSS_IGNORE"
        melos exec -c 1 -- "mkdir -p lib/generated/oss/ && dart run dart_pubspec_licenses:generate -o lib/generated/oss/oss.dart -i $OSS_IGNORE"
      packageFilters:
        dependsOn:
          - "dart_pubspec_licenses"
      description: Generate OSS license file for the main app

    localize:
      run: melos exec "dart run slang"
      packageFilters:
        dependsOn:
          - "slang"
      description: Run Slang

    update_packages:
      run:
        melos exec -c 1 --order-dependents -- "flutter pub upgrade && flutter pub
        upgrade --major-versions"
      description: Upgrade All Packages.

    use_fvm:
      run: fvm use --skip-pub-get || echo "fvm not found, skipping"
      description: Run fvm use if fvm is installed
''';
