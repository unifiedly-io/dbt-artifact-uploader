with vals as (
    select
        api_data:results as res,
        value:guid as guid
    from {{ ref('unifiedly_selectstar_data_sources_list') }}, lateral flatten(input => res) as f
    )
select
    guid
    , data_build_tool_dbt__select_star_integration_by_unifiedly.public.selectstar_get(concat_ws('/', 'data-sources', guid), {}) as api_data
from vals
