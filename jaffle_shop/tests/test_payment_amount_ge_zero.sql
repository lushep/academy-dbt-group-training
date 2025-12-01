select * from {{ source('stripe', 'payments') }}
where payment_amount < 0