/// Joins `import` directives in alphabetical order, as `directives_ordering`
/// expects within a single section (e.g. all `package:` imports).
String sortImports(List<String> imports) => ([...imports]..sort()).join('\n');
