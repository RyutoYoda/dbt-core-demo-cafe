with products as (

    select * from {{ ref('stg_products') }}

)

select
    {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,
    *
from products
