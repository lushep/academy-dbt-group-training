with orders as 
(
    select * from {{ ref("stg__jaffle_shop__orders") }}
)

, payments as 
(
    select * from {{ ref("stg__stripe__payments") }}
)

, int_order_payments as 
(
    select * from {{ ref("int_order_payments") }}
)

{% set payment_methods = distinct_payment_methods() %}

select
  o.order_id
, o.customer_id
, o.order_date 
, SUM(coalesce(p.amount, 0)) AS total_paid,
   {%- for payment_method in payment_methods %}
   sum({{payment_method}}_amount) as {{payment_method}}_amount
   {%- if not loop.last %},{% endif -%}
   {% endfor %}
, COUNT(p.payment_id) AS amount_of_payees
from orders AS o 
LEFT JOIN payments AS p using (order_id)
LEFT JOIN int_order_payments AS iop using (order_id)
group by o.order_id, o.customer_id, o.order_date