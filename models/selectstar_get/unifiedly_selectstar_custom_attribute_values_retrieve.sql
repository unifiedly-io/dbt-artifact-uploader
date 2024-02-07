with vals as (
    select
        api_data:results as res,
        value:guid as guid
    from {{ ref('unifiedly_selectstar_custom_attribute_values_list') }}, lateral flatten(input => res) as f
    )
select
    guid
    , unifiedly.public.selectstar_get(concat_ws('/', 'custom-attribute-values', guid), {}) as api_data
from vals
