{{
    config(
        error_if='>65',
        warn_if='>0'
    )
}}
select * 
from {{ ref('dim_customers') }}
where number_of_orders > 0