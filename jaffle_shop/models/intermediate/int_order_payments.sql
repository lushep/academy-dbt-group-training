--List
{% set payment_methods = ['credit_card', 'gift_card', 'coupon', 'bank_transfer'] %}

--Kan ook zoals hieronder met column waardes zoeken in de kolom
{#-- {% set payment_methods = dbt.utils.get_column_values(source('stripe', 'payments'), 'payment_method') %}   #}

--Can we remove trailing comma?
-- Yes, look at loop.last Jinja

select 
order_id,
{% for payment_method in payment_methods %}
sum(case when payment_method='{{payment_method}}' then payment_amount else 0 end) as {{payment_method}}_amount
{%-if not loop.last %},{%endif-%}
{% endfor %}
from {{ ref("stg_stripe__payments") }}
group by 1
order by order_id