{% macro selectstar_ingestion_dbt() %}

{% do log("Pushing to Select Star via Unifiedly", info=True) %}
{% set results = run_query(_selectstar_ingestion_dbt()) %}
{% do log("Unifiedly Response: " + results.columns[0].values(), info=True) %}
{% do print(results.columns.values()) %}

{% endmacro %}