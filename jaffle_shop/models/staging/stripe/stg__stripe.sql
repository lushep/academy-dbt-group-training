select payment_id,
    order_id,
    payment_method,
    {{ convert_cents_to_dollars('payment_amount') }} as payment_amount
from {{ source('stripe', 'payment' )}}