SELECT *
FROM {{ source('stripe', 'payments') }}
order by order_id