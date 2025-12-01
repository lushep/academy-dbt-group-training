select 
   payment_id
,  order_id
,  payment_method
,  payment_amount as amount
from {{source ('stripe', 'payments')}}