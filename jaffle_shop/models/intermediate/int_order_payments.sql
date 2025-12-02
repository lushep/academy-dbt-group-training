{% set payment_methods = dbt_utils.get_column_values(ref("stg__stripe"), 'payment_method') %}

select 
order_id,
{%- for payment_method in payment_methods -%}
--{{ payment_method }}
sum(case when payment_method = '{{ payment_method }}' then payment_amount else 0 end) as {{ payment_method }}_amount
{% if not loop.last %},{% endif %}
{%- endfor -%}
from {{ ref('stg__stripe')}}
group by order_id
order by order_id
