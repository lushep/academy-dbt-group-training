{macro payment_methods()}
{% set column_names = dbt_utils.get_filtered_columns_in_relation(from=ref('int_order_payments'), except=["order_id"]) %}
{endmacro}