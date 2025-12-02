{% set payment_methods = {{ distinct_payment_methods() }} %}


select 
   order_id,
   {%- for payment_method in payment_methods %}
   sum(case when payment_method = '{{payment_method}}' then amount else 0 end) as {{payment_method}}_amount
   {%- if not loop.last %},{% endif -%}
{% endfor %}
from {{ref('stg__stripe__payments')}}
group by order_id
order by order_id

