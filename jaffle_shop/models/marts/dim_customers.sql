with customers as (

select * from {{ ref('stg_jaffle_shop__customers') }}

),

orders as (

select * from dbt_jklingenberg.stg_jaffle_shop__orders

),

payments as (
    SELECT * FROM {{ ref('stg_stripe_payments') }}
),

factorders as (
    SELECT * FROM 
    {{ ref('fct_orders') }}
),

customer_orders as (

    select
        customer_id,

        min(orders.order_date) as first_order_date,
        max(orders.order_date) as most_recent_order_date,
        count(orders.order_id) as number_of_orders

    from orders orders

    group by 1

),


intermediate_final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders
    from customers
    left join customer_orders using (customer_id)

),

final as
(
    SELECT intermediate_final.*, 
            SUM(factorders.amount) as customer_lifetime_value
    FROM intermediate_final
    JOIN factorders
    on intermediate_final.customer_id = factorders.customer_id
    GROUP BY ALL
)

select * from final
