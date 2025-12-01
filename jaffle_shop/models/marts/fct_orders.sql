with orders as (

    select
        *
    from {{ ref('stg_jaffle_shop__orders') }}

),

customer_orders as (

    select
        order_id,

        min(orders.order_date) as first_order_date,
        max(orders.order_date) as most_recent_order_date,
        count(orders.order_id) as number_of_orders

    from orders orders

    group by 1

),

payments as (

    select
        order_id,
        min(payment_method) as payment_type,
        sum(payment_amount) as total_amount
    from {{ ref('stg_stripe__payments') }}

    group by 1
),

order_payments as(
    select
    *
    from payments
    left join customer_orders using (order_id)
),

final as(
    select
    sum(total_amount)/100 as all_time_revenue
    from order_payments
)

select * from final



