# unifiedly-dbt

This dbt package works with the commercial product [Unifiedly](unifiedly.io) to make API calls within Snowflake and dbt easy and accessible.

Unifiedly is a Snowflake Native App and can be found on the [Snowflake App Marketplace](https://app.snowflake.com/marketplace/listing/GZSUZHTVEF/unifiedly-unifiedly-api-connector).

Some features of this package will not work unless the app has been installed and configured.

## Example API usage

Retrieving data from API's depends on the endpoint but is largely Pythonic.

For example to get a list of all columns from Select Star the code is as simple as: 
```
select
    unifiedly.public.selectstar_get('columns', {}) as api_data
```
Note that this package offers many models which can be referenced from within your dbt project to avoid interacting directly with the API.
However the ability is there if you want to customize.

For many more examples which utilize this package including the models see the [dbt-demo-project](https://github.com/unifiedly-io/dbt-demo-project).

## Contributing

We welcome any additions with new models, suggestions for more endpoints etc.

## Other features

In addition to making API calls this package also provides a mechanism to upload json artifacts into snowflake for querying and use with Unifiedly Snowflake app.

Prior to using this package ensure there is a source configured as below within your dbt project, this will tell dbt where Unifiedly expects your artifacts to be stored:
```
version: 2

sources:
  - name: dbt_artifacts
    database: artifacts
    schema: dbt_artifacts  
    tables:
      - name: artifacts

```
## Usage notes

To use this package first run a dbt command such as `dbt docs generate` to ensure all dbt artifacts are present. Then use `dbt --no-write-json run-operation` to upload artifacts to Snowflake. Note the inclusion of `--no-write-json` when calling `run-operation`. This is mandatory because it preserves the artifacts from the previous dbt command.

## Example upload usage

### Process a dbt command and use Unifiedly Snowflake Application to instantly push metadata to partner applications
```
dbt build && dbt --no-write-json run-operation upload_dbt_artifacts
```

### Process a dbt command and upload only the manifest artifact
```
dbt compile --full-refresh && dbt --no-write-json run-operation upload_dbt_artifacts --args '{filenames: ['manifest.json']}'
```

### Arbitrary metadata in the form of a dictionary can be included with your artifacts to help further analysis
```
dbt compile --full-refresh && dbt --no-write-json run-operation upload_dbt_artifacts --args '{filenames: ['manifest.json'], meta: "{\"arbitrarily\": {\"nested\": \"metadata\"}}"}'
```

### Combine uploaded artifacts with pushing metadata to partner applications API's
```
dbt compile --full-refresh && dbt --no-write-json run-operation upload_dbt_artifacts --args '{filenames: ['manifest.json'], meta: "{\"arbitrarily\": {\"nested\": \"metadata\"}}"}' && dbt run-operation selectstar_ingestion_dbt
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
