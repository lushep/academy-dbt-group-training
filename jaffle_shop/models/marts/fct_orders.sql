with grouped_payments as (
    select order_id, sum(payment_amount) as payment_per_order
    from {{ref('stg_stripe__payments')}}
    group by order_id
),

order_customer as
(
    select order_id, customer_id
    from {{ref('stg_jaffle_shop__orders')}}
),
payment_per_customer as
(
    select customer_id, sum(payment_per_order) as payment_per_customer
    from order_customer
    left join grouped_payments on order_customer.order_id = grouped_payments.order_id
    group by order_customer.customer_id

)
select * from payment_per_customer


