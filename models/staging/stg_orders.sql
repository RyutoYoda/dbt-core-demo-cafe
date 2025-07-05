with source as (

    select * from {{ source('main', '注文') }}

),

renamed as (

    select
        "注文ID" as order_id,
        "会員ID" as customer_id,
        "店舗ID" as store_id,
        "注文日時" as ordered_at,
        "注文方法" as order_method,
        "満足度" as satisfaction_level,
        "利用シーン" as usage_scenario

    from source

)

select * from renamed
