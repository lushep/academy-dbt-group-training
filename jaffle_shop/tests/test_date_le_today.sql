SELECT order_date
FROM {{ source('jaffle_shop', 'orders') }}
where order_date > CURRENT_DATE()