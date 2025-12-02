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

int_orders_payments as (
    select
        *
    from {{ref("int_orders_payments")}}
),


final_fact_orders as(

select 
    orders.order_id,
    orders.customer_id,
    payments.payment_amount,
    int_orders_payments.credit_card
    from orders
    left join payments on payments.order_id = orders.order_id
    left join int_orders_payments on int_orders_payments.order_id = payments.order_id
    group by all
) 

select * from final_fact_orders