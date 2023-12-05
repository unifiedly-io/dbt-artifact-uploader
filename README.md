# dbt-artifact-uploader

Provides a mechanism to upload json artifacts into snowflake for use with unifieDocs Snowflake app.

To use this package first run `dbt docs generate` to ensure all dbt artifacts are present. Then use `dbt run-operation` to upload artifacts to Snowflake.


Example usage:
```
dbt docs generate && dbt run-operation upload_dbt_artifacts --args '{filenames: [manifest, run_results, catalog]}'
```
