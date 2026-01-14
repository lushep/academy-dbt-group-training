with 

source as (

    select * from {{ source('stripe', 'payments') }}

),

renamed as (

    select
        payment_id,
        order_id,
        payment_method,
        payment_amount/100 as payment_amount

    from source

)

select * from renamed