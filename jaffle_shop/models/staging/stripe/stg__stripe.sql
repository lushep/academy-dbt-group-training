select payment_id,
    order_id,
    payment_method,
    payment_amount
from {{ source('stripe', 'payment' )}}