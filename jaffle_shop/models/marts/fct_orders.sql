with orders as 
(
    select * from {{ ref("stg__jaffle_shop__orders") }}
)

, payments as 
(
    select * from {{ ref("stg__stripe__payments") }}
)

select
  o.order_id
, o.customer_id
, o.order_date 
, SUM(coalesce(p.amount, 0)) AS total_paid
, COUNT(p.payment_id) AS amount_of_payees
from orders AS o 
LEFT JOIN payments AS p using (order_id)
group by o.order_id, o.customer_id, o.order_date