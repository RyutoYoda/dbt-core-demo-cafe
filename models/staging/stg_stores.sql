/*
このモデルは、店舗マスタデータを扱うためのステージングモデルです。

- `source('main', '店舗マスタ')`: 'main'スキーマにある'店舗マスタ'テーブルを参照しています。
- カラム名の変更: 日本語のカラム名を英語にリネームしています。
*/

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
