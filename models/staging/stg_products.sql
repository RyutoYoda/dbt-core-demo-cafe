with source as (

    select * from {{ source('main', '商品マスタ') }}

),

renamed as (

    select
        "商品ID" as product_id,
        "商品名" as product_name,
        "カテゴリ" as category,
        "価格" as price,
        "カスタマイズ有無" as is_customizable

    from source

)

select * from renamed
