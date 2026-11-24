/// One clean-helper command, described for AI agents working in a generated
/// project. Rendered to `.agents/commands/<name>.md` by
/// `agentContextCommandTemplate`.
typedef AgentCommandDoc = ({
  String name,
  String usage,
  String summary,
  String whenToUse,
  String details,
});

/// The commands an agent may run in a generated project, in the order they
/// are usually needed.
const agentCommandDocs = <AgentCommandDoc>[
  (
    name: 'add-feature',
    usage:
        'clean-helper add-feature <feature_name> [--di] '
        '[--bloc-name=<name>] [--no-bloc]',
    summary: 'Adds a feature: router, navigation, bloc, page provider, page.',
    whenToUse: 'For every new screen or flow.',
    details: '''
- snake_case name, not the app's name. `--di` adds `di/<f>_module.dart`.
- `--bloc-name` names the bloc differently; `--no-bloc` makes a page
  without one.
- Set the router's `priority` from the router package's priority bands.
- Makes `router/` and `presentation/` only; run `add-repo` for data.
- Registers the router in the tool-owned router module.''',
  ),
  (
    name: 'add-repo',
    usage: 'clean-helper add-repo <feature> <repo_name> [--add-sample] [--no-rest]',
    summary: 'Adds `domain/` and `data/` for a repository to a feature.',
    whenToUse: 'Whenever a feature needs data.',
    details: '''
- `--add-sample` adds sample `get` / `post` methods at every layer.
- The REST datasource and API paths need the network module; `--no-rest`
  skips them.''',
  ),
  (
    name: 'add-entity',
    usage: 'clean-helper add-entity <feature|core> <entity_name> [folder]',
    summary: 'Adds a domain entity and the freezed model implementing it.',
    whenToUse:
        'For a domain type not tied to one repository. Use `core` only '
        'for infrastructure types; business types go in a feature or '
        '`lib/shared/`.',
    details: '',
  ),
  (
    name: 'add-network-module',
    usage: 'clean-helper add-network-module',
    summary: 'Creates the network package and wires the app to it.',
    whenToUse: 'Once, if the app was created with `--skip-network`.',
    details: '',
  ),
  (
    name: 'remove-feature',
    usage: 'clean-helper remove-feature <feature_name>',
    summary: 'Deletes a feature and unregisters its router.',
    whenToUse: 'To delete a feature. Never delete feature folders by hand.',
    details: '''
- Afterwards, fix only the `lib/app/navigation/` impls that pointed at it.''',
  ),
  (
    name: 'regenerate-router',
    usage: 'clean-helper regenerate-router',
    summary: 'Rebuilds the router module from the feature routers on disk.',
    whenToUse: 'When the router module is out of sync (e.g. after a merge).',
    details: '',
  ),
  (
    name: 'build-runner',
    usage: 'clean-helper build-runner [build|clean]',
    summary: 'Runs build_runner in the app.',
    whenToUse:
        'After changing freezed, json_serializable, injectable or '
        'Retrofit sources.',
    details: '',
  ),
  (
    name: 'generate-localizations',
    usage: 'clean-helper generate-localizations',
    summary: 'Runs slang in the localization package.',
    whenToUse: 'After editing the locale JSON files.',
    details: '',
  ),
  (
    name: 'bootstrap',
    usage: 'clean-helper bootstrap',
    summary: '`pub get`, slang, then build_runner in the packages and the app.',
    whenToUse: 'After a clone, or a pull that changed dependencies.',
    details: '',
  ),
  (
    name: 'create-foundation',
    usage: 'clean-helper create-foundation [--dir=<path>]',
    summary: 'Creates the configured foundation packages.',
    whenToUse: 'Once, at a monorepo root, before the apps run `init`.',
    details: '',
  ),
  (
    name: 'list-mono-repo-apps',
    usage: 'clean-helper list-mono-repo-apps',
    summary: 'Prints the monorepo apps and how every config key resolves.',
    whenToUse: 'To check package names or config before generating code.',
    details: '',
  ),
];
