with Payments as (
select *
from {{ ref('stg__stripe')}}
)

,Orders as (
select *
from {{ ref('stg__jaffle_shop__orders')}}
)
/*
,PaymentsPerOrder as (
select order_id,
    SUM(payment_amount) as PaymentAmountPerOrder
from Payments
group by order_id
)
*/

,int_orders as (
    select * from {{ ref('int_order_payments')}}
)


select
    Orders.order_id,
    int_orders.* except (order_id)
  --  PaymentsPerOrder.PaymentAmountPerOrder
from Orders as Orders
left join int_orders as int_orders
    on int_orders.order_id = Orders.order_id
--left join PaymentsPerOrder as PaymentsPerOrder
  --  on PaymentsPerOrder.order_id = Orders.order_id