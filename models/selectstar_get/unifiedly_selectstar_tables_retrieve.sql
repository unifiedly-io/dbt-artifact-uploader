with vals as (
    select
        api_data:results as res,
        value:guid as guid
    from {{ ref('unifiedly_selectstar_tables_list') }}, lateral flatten(input => res) as f
    )
select
    guid
    , unifiedly.public.selectstar_get(concat_ws('/', 'tables', guid), {}) as api_data
from vals
