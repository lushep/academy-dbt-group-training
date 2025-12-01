with 
payments as (
    select
        order_id,
        SUM(payment_amount) as payment_amount
        from {{ ref('stg_stripe_payments')}}
        group by order_id    
),
orders as (
    select
        *
    from {{ref("stg_jaffle_shop__orders")}}
),

final_fact_orders as(

select 
    orders.order_id,
    orders.customer_id,
    payments.payment_amount
    from orders
    left join payments on payments.order_id = orders.order_id

)

select * from final_fact_orders