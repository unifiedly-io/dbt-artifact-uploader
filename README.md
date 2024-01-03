# dbt-artifact-uploader

Provides a mechanism to upload json artifacts into snowflake for use with unifieDocs Snowflake app.

Prior to using this package ensure there is a source configured as below within your dbt project, this will tell dbt where unifieDocs expects your artifacts to be stored:
```
version: 2

sources:
  - name: dbt_artifacts
    database: unifiedocs  
    schema: dbt_artifacts  
    tables:
      - name: artifacts

```
## Usage notes

To use this package first run a dbt command such as `dbt docs generate` to ensure all dbt artifacts are present. Then use `dbt --no-write-json run-operation` to upload artifacts to Snowflake. Note the inclusion of `--no-write-json` when calling `run-operation`. This is mandatory because it preserves the artifacts from the previous dbt command.

## Example usage

### Build the project and upload the manifest and run_results to Snowflake
```
dbt build && dbt --no-write-json run-operation upload_dbt_artifacts --args '{filenames: [manifest, run_results]}'
```

### Generate docs and upload the manifest, run_results and catalog to Snowflake
```
dbt docs generate && dbt --no-write-json run-operation upload_dbt_artifacts --args '{filenames: [manifest, run_results, catalog]}'
```

### Run the project and upload the manifest and run_results to Snowflake
```
dbt run && dbt --no-write-json run-operation upload_dbt_artifacts --args '{filenames: [manifest, run_results]}'
```

### Tests the project and upload the manifest and run_results to Snowflake
```
dbt test && dbt --no-write-json run-operation upload_dbt_artifacts --args '{filenames: [manifest, run_results]}'
```

### Compile a full manifest and upload it to Snowflake

```
dbt compile --full-refresh && dbt --no-write-json run-operation upload_dbt_artifacts --args '{filenames: [manifest]}'
```