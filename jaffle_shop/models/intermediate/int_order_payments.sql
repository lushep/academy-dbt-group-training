{%- set payment_methods = get_payment_method_values() %}
select 
    order_id,
    {%- for payment_method in payment_methods -%}
    -- {{ payment_method }}
    sum(case when payment_method = '{{ payment_method }}' then payment_amount else 0 end) as {{ payment_method }}_amount
    {%- if not loop.last -%},{% endif %}
    {% endfor %}
from {{ ref('stg_stripe_payments') }}
group by order_id