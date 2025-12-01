--test data less than or equal to today
select * from {{ ref("stg__jaffle_shop__orders")}}
where 1=1
and order_date > current_date()
