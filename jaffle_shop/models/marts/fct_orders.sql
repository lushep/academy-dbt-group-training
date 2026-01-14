with orders as (

    select
        *
    from  {{ ref('stg_jaffle_shop__orders') }}

),

payments as (

    select
        *
    from  {{ ref('stg_stripe__payments') }}

),


order_payments as (

    select
        order_id,
        sum(payment_amount) as order_amount

    from payments

    group by 1

),


final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        order_payments.order_amount

    from orders

    left join order_payments using (order_id)

)

select * from final
