# Command: add-entity

**Entry point:** `lib/src/commands/add_entity.dart` → `addEntity(args, {runBuildRunnerAfter})`
**Runner:** `AddEntityCommand`

## Usage

```bash
clean-helper add-entity <feature|core> <entity_name> [folder]
clean-helper add-entity home invoice
clean-helper add-entity home invoice requests
clean-helper add-entity core error
```

## Output

| Scope | Entity | Model |
|---|---|---|
| `<feature>` | `lib/features/<f>/domain/entities/<n>_entity.dart` | `lib/features/<f>/data/models/[<folder>/]<n>_model.dart` |
| `core` | `lib/core/domain/entities/<n>_entity.dart` | `lib/core/data/models/[<folder>/]<n>_model.dart` |

- **Entity** (`entity` template): `abstract class <N>Entity {}`.
- **Model** (`model` template): a `@freezed sealed class <N>Model with _$<N>Model implements <N>Entity`, with `fromJson`, plus `part` files for freezed and json_serializable. Its relative import of the entity is one level deeper when a `folder` is given.

Then it runs `runDartFormat()` and `runBuildRunner()`. Both files use `writeFile`.
