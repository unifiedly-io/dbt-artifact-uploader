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

To use this package first run `dbt docs generate` to ensure all dbt artifacts are present. Then use `dbt run-operation` to upload artifacts to Snowflake.


Example usage:
```
dbt docs generate && dbt run-operation upload_dbt_artifacts --args '{filenames: [manifest, run_results, catalog]}'
```
