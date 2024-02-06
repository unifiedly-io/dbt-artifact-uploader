with vals as (
    select
        api_data:results as res,
        value:guid as guid
    from {{ ref('selectstar_custom_attribute_values_list') }}, lateral flatten(input => res) as f
    )
select
    guid
    , data_build_tool_dbt__select_star_integration_by_unifiedly.public.selectstar_get(concat_ws('/', 'custom-attribute-values', guid), {}) as api_data
from vals
