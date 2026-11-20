import '../functions/agent_context/agent_command_docs.dart';

/// `.agents/commands/<name>.md`: one clean-helper command for AI agents.
String agentContextCommandTemplate(AgentCommandDoc doc) =>
    '''
# `clean-helper ${doc.name}`

${doc.summary}

**Use it:** ${doc.whenToUse}

```bash
${doc.usage}
```

${doc.details}
''';
