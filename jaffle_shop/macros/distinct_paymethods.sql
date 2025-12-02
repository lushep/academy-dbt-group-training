{% macro distinct_payment_methods() %}
    
{% set payment_methods = dbt_utils.get_column_values(table = ref('stg__stripe__payments'), column='payment_method') %}

{% endmacro %}