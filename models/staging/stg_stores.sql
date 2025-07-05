with source as (

    select * from {{ source('main', '店舗マスタ') }}

),

renamed as (

    select
        "店舗ID" as store_id,
        "店舗名" as store_name,
        "所在地" as location,
        "オープン日" as opened_at

    from source

)

select * from renamed
