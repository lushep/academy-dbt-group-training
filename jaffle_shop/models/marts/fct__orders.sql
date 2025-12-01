with Payments as (
select *
from {{ ref('stg__stripe')}}
)

,Orders as (
select *
from {{ ref('stg__jaffle_shop__orders')}}
)

,PaymentsPerOrder as (
select order_id,
    SUM(payment_amount) as PaymentAmountPerOrder
from Payments
group by order_id
)

select
    Orders.order_id,
    PaymentsPerOrder.PaymentAmountPerOrder
from Orders as Orders
left join PaymentsPerOrder as PaymentsPerOrder
    on PaymentsPerOrder.order_id = Orders.order_id