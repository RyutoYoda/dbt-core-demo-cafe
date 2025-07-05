/*
このモデルは、注文データを扱うためのステージングモデルです。
注文明細と同様に、日本語のカラム名を英語の分かりやすい名前に変更しています。

- `source('main', '注文')`: 'main'スキーマにある'注文'テーブルを参照しています。
- カラム名の変更: 日本語のカラム名を英語にリネームしています。
*/

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
