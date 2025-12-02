{% macro get_payment_method_values() %}

{%- set payment_methods = dbt_utils.get_column_values(table=ref('stg_stripe_payments'), column='payment_method') %}

{{ return(payment_methods) }}

{% endmacro %}