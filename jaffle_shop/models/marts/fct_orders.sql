WITH payments AS(
    SELECT * FROM {{ ref('stg_stripe_payments') }}
),

orders as (
    SELECT * FROM {{ ref('stg_jaffle_shop__orders') }}
),

final as (
SELECT
    orders.order_id,
    orders.customer_id,
    SUM(payments.payment_amount) as amount
FROM orders
LEFT JOIN payments
ON orders.order_id = payments.order_id
GROUP BY orders.order_id, orders.customer_id
)
SELECT * FROM final