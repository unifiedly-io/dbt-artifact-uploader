{% macro upload_dbt_artifacts(instant_push=True) %}

{% set src_dbt_artifacts = source('dbt_artifacts', 'artifacts') %}

{{ create_artifact_resources() }}

{% set remove_query %}
    remove @{{ src_dbt_artifacts }} pattern='.*.json.gz';
{% endset %}

{% do log("Clearing existing files from Stage: " ~ remove_query, info=True) %}
{% do run_query(remove_query) %}

{# Put all json files into the stage: Returns a tuple of all files that got uploaded #}
{% set put_query %}
    put file://target/*.json @{{ src_dbt_artifacts }} auto_compress=true;
{% endset %}

{% do log("Uploading " ~ file ~ " to Stage: " ~ put_query, info=True) %}
{% set results = run_query(put_query) %}
{% do log("Staged artifacts: " ~ results.columns[0].values(), info=True) %}
{% set staged_artifacts = results.columns[0].values() %}

{# Filter the objects that went into the stage to only the default dbt metadata #}
{% set valid_artifacts = ['manifest.json', 'run_results.json', 'catalog.json']  %}
{% set filtered_artifacts = []  %}

{% for val in staged_artifacts %}
  {% if val in valid_artifacts %}
    {{ filtered_artifacts.append(val) }}
  {% endif %}
{% endfor %}

{% do log("Filtered artifacts: " ~ filtered_artifacts, info=True) %})

{# Push valid metadata objects into the metadata table #}
{% for filename in filtered_artifacts %}

    {% set file = filename %}
    
    print(filename)


    {% set copy_query %}
        begin;
        copy into {{ src_dbt_artifacts }} from
            (
                select
                '{{ project_name }}' as project_name,
                $1 as data,
                $1:metadata:generated_at::timestamp_ntz as generated_at,
                metadata$filename as path,
                regexp_substr(metadata$filename, '([a-z_]+.json)') as artifact_type
                from  @{{ src_dbt_artifacts }}
            )
            file_format=(type='JSON')
            on_error='skip_file';
        commit;
    {% endset %}

    {% do log("Copying " ~ file ~ " from Stage: " ~ copy_query, info=True) %}
    {% do run_query(copy_query) %}

{% endfor %}

{% do log("Clearing new files from Stage: " ~ remove_query, info=True) %}
{% do run_query(remove_query) %}

{% if instant_push %}
    {% do log("Pushing via Unifiedly", info=True) %}
    {% set results = run_query("call DATA_BUILD_TOOL_DBT__SELECT_STAR_INTEGRATION_BY_UNIFIEDLY.PUBLIC.PROCESS_ARTIFACTS()")%}
    {% do log("Unifiedly Response:", info=True) %}
    {% do print(results.columns[0].values()) %}
{% endif %}
{% endmacro %}
