with vals as (
    select
        api_data:results as res,
        value:guid as guid
    from {{ ref('selectstar_columns_list') }}, lateral flatten(input => res) as f
    )
select
    guid
    , data_build_tool_dbt__select_star_integration_by_unifiedly.public.selectstar_get(concat_ws('/', 'columns', guid), {}) as api_data
from vals
