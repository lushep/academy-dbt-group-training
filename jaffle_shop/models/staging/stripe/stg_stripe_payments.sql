select 
    payment_id,
    order_id,
    payment_method,
    payment_amount/100 as final_amount
from {{ source("stripe", 'payments') }}