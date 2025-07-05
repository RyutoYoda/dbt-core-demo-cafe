with stores as (

    select * from {{ ref('stg_stores') }}

)

select
    {{ dbt_utils.generate_surrogate_key(['store_id']) }} as store_key,
    *
from stores
