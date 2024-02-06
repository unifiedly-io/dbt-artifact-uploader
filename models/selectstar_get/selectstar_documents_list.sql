select
    current_timestamp() as loaded_datetime
    , data_build_tool_dbt__select_star_integration_by_unifiedly.public.selectstar_get('documents', {}) as api_data