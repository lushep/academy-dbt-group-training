

with customers as (

select * from
{{ ref('stg_jaffle_shop__customers') }}
),

orders as (

select * from {{ref('stg_jaffle_shop__orders')}}

),


customer_orders as (

select * from {{ref('int_jaffle_shop__customer_orders')}}

),

payment_per_customer as(
    select * from {{ref('fct_orders')}}

),


final as (

    select

        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        payment_per_customer.payment_per_customer as lifetime_value,
        payment_per_customer.payment_per_customer / customer_orders.number_of_orders as average_order_value
    from customers

    left join customer_orders using (customer_id)

    left join payment_per_customer using (customer_id)


)

select * from final
