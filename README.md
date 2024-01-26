# dbt-artifact-uploader

Provides a mechanism to upload json artifacts into snowflake for use with Unifiedly Snowflake app.

Prior to using this package ensure there is a source configured as below within your dbt project, this will tell dbt where Unifiedly expects your artifacts to be stored:
```
version: 2

sources:
  - name: dbt_artifacts
    database: unifiedly  
    schema: dbt_artifacts  
    tables:
      - name: artifacts

```
## Usage notes

To use this package first run a dbt command such as `dbt docs generate` to ensure all dbt artifacts are present. Then use `dbt --no-write-json run-operation` to upload artifacts to Snowflake. Note the inclusion of `--no-write-json` when calling `run-operation`. This is mandatory because it preserves the artifacts from the previous dbt command.

## Example usage

### Process a dbt command and use Unifiedly Snowflake Application to instantly push metadata to partner applications
```
dbt build && dbt --no-write-json run-operation upload_dbt_artifacts
```

### Process a dbt command and upload only the manifest artifact, then instantly push metadata to partner applications
```
dbt compile --full-refresh && dbt --no-write-json run-operation upload_dbt_artifacts --args '{filenames: ['manifest.json']}'
```

### Process a dbt command and upload to Snowflake without syncing
```
dbt build && dbt --no-write-json run-operation upload_dbt_artifacts --args '{instant_push: False}'
```

## Additional Examples
```
dbt docs generate && dbt --no-write-json run-operation upload_dbt_artifacts
```

```
dbt run && dbt --no-write-json run-operation upload_dbt_artifacts
```

```
dbt test && dbt --no-write-json run-operation upload_dbt_artifacts
```

```
dbt compile --full-refresh && dbt --no-write-json run-operation upload_dbt_artifacts --args '{filenames: ['manifest.json']}'
```
