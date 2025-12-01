select
    t1.order_id,
    t2.customer_id,
    SUM(t1.final_amount) as amount
from {{ ref('stg_stripe_payments') }} t1
inner join {{ref('stg_jaffle_shop_orders')}} t2
    on t1.order_id = t2.order_id
group by
    t1.order_id,
    t2.customer_id