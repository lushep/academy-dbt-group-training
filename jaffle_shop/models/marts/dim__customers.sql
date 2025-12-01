with customers as (

    select
        customer_id,
        first_name,
        last_name
    from {{ ref('stg__jaffle_shop__customers')}}

),

orders as (

    select
        order_id,
        customer_id,
        order_date,
        status

    from {{ ref('stg__jaffle_shop__orders')}}

),

payments as (
    select
    payment_id,
    order_id,
    payment_method,
    payment_amount
from {{ ref('stg__stripe')}}
)
,

TotalPaymentsPerCustomer as (
select customers.customer_id
, sum(payments.payment_amount) as TotalAmountPerCustomer
from customers as customers
left join orders as orders
    on orders.customer_id = customers.customer_id
left join payments as payments
    on payments.order_id = orders.order_id
group by customers.customer_id    
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


final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        TotalPaymentsPerCustomer.TotalAmountPerCustomer as lifetime_value
    from customers
    left join customer_orders using (customer_id)
    left join TotalPaymentsPerCustomer as TotalPaymentsPerCustomer
        on TotalPaymentsPerCustomer.customer_id = customers.customer_id

)

select * from final