with orders as (
    select * from {{ ref("stg_jaffle_shop__orders") }}
),

payments as (
    select * from {{ ref("stg_stripe__payments")}}
),

final as (
    select 
        order_id,
        customer_id,
        sum(payment_amount) as amount
    from orders
    left join payments using (order_id)
    group by order_id, customer_id
)

select * from final