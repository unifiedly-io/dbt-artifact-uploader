{% macro upload_dbt_artifacts() %}
-- Gather the dbt artifacts which have been uploaded for each project
with artifacts as (
    SELECT
        p.project_name,
        p.catalog::variant as catalog,
        p.manifest::variant as manifest,
        p.run_results::variant as run_results
    from (
        -- Get the latest of each artifact type for each project
        select project_name, data, artifact_type from {{ source('dbt_artifacts', 'artifacts') }}
        qualify row_number() over (partition by project_name, artifact_type order by generated_at desc) = 1
    )
    -- We need them to be all in a single row so that they are accessable when calling the API
    pivot(max(data) for artifact_type in ('catalog.json', 'manifest.json', 'run_results.json'))
        as p (project_name, catalog, manifest, run_results)
)
-- We need to send the data with GUID to identify each data source
-- So we create a table with the name and GUID as currently found in Select Star
-- by calling the data-sources api
, data_sources as (
    select
        res.value:name::varchar as name
        , res.value:guid::varchar as guid
    from (
        select 
            api_data:results as results
        from (
        select unifiedly_app_instance
            .public.selectstar_get('data-sources', {}) as api_data
            )
    ), lateral flatten(input=> results) as res
)
-- Joining the GUID into the artifacts data gives us everything we need to call
-- the ingestion API
, prepped_data as (
    select
        name
        , guid
        , manifest
        , catalog
        , run_results
    from data_sources
    join artifacts on data_sources.name = artifacts.project_name
)
-- We call the ingestion API for dbt and provide the artifacts as JSON objects
-- The API returns the data source GUID if it was successful so we add a check
-- so that we can validate the response by parsing the return and comparing to
-- the guid column
select
    current_timestamp() as processed_datetime
    , name
    , guid
    , unifiedly_app_instance.public.selectstar_post(
        'ingestion/dbt',
        {
            'data_source': guid
        },
        {},
        {
            'manifest_file': to_json(manifest),
            'catalog_file': to_json(catalog),
            'run_results_file': to_json(run_results)
        }
    ) as api_response
    , case
        when api_response:data_source = guid then TRUE
        else FALSE
    end as update_successful
    from prepped_data
{% endmacro %}