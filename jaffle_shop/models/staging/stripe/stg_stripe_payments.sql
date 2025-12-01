SELECT *
FROM {{ source('stripe', 'payments') }}