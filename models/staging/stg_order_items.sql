with source as (

    select * from {{ source('main', '注文明細') }}

),

renamed as (

    select
        "注文明細ID" as order_item_id,
        "注文ID" as order_id,
        "商品ID" as product_id,
        "数量" as quantity

    from source

)

select * from renamed
