with orders as (
    select * from {{ ref("stg_jaffle_shop__orders") }}
),

payments as (
    select * from {{ ref("stg_stripe__payments")}}
),

int_order_payments as (
    select * from {{ ref("int_order_payments") }}
),

final as (
    select 
        order_id,
        customer_id,
        sum(payment_amount) as amount,
        {{ dbt_utils.star(from=ref('int_order_payments'), except=["order_id"], quote_identifiers=False) }}
    from orders
    left join payments using (order_id)
    left join int_order_payments using (order_id)
    group by order_id, customer_id, {{ dbt_utils.star(from=ref('int_order_payments'), except=["order_id"], quote_identifiers=False) }}
)

select * from final