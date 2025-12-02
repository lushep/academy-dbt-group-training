
--declare variables in a list
-- {% set payment_methods = ['credit_card', 'gift_card', 'coupon', 'bank_transfer'] %}

{% set payment_methods = dbt_utils.get_column_values(source('stripe','payments'), 'payment_method') %}

select 
    order_id,
--in a condition checking the payment method in the list declared using set
{% for payment_method in payment_methods %}
--aggregation
sum(case when payment_method = '{{ payment_method }}' then payment_amount else 0 end) as {{ payment_method }},
--ending the for
{% endfor %}
from {{ ref('stg_stripe_payments') }}
group by 1
order by 1