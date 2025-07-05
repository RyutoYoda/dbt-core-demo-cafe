with source as (

    select * from {{ source('main', 'customers') }}

),

renamed as (

    select
        customer_id,
        customer_name,
        email,
        {{ dbt_utils.generate_surrogate_key(['customer_id']) }} as customer_key

    from source

)

select * from renamed
