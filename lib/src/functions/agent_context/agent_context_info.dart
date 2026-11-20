/// What `.agents/` describes, resolved from `clean-helper:` config.
///
/// In a monorepo, a package without a configured name is shown as
/// `<app>_<kind>` (each app gets its own default).
typedef AgentContextInfo = ({
  String projectName,
  List<String> apps,
  String foundationDir,
  String utils,
  String localization,
  String router,
  String theme,
  String network,
  String callAdapter,
  bool auth,
});
