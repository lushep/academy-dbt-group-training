WITH payments AS(
    SELECT * FROM {{ ref('stg_stripe_payments') }}
),

orders as (
    SELECT * FROM {{ ref('stg_jaffle_shop__orders') }}
),

intorder_payments as (
SELECT * FROM {{ ref('int_order_payments') }}
),

final as (
SELECT
    orders.order_id,
    orders.customer_id,
    SUM(payments.payment_amount) as amount,
    intorder_payments.credit_card_amount,
    intorder_payments.gift_card_amount,
    intorder_payments.bank_transfer_amount,
    intorder_payments.coupon_amount
FROM orders
LEFT JOIN payments
ON orders.order_id = payments.order_id
LEFT JOIN intorder_payments
ON intorder_payments.order_id = orders.order_id
GROUP BY ALL
)
SELECT * FROM final