/*
このモデルは、カフェの顧客データを扱うためのステージングモデルです。
ステージングモデルは、データソース（この場合は'main'スキーマの'customers'テーブル）からデータを読み込み、
基本的な整形（カラム名の変更など）を行う責務を持ちます。

- `source('main', 'customers')`: dbtのsource機能を使って、'main'スキーマにある'customers'テーブルを参照しています。
- `dbt_utils.generate_surrogate_key`: dbt_utilsパッケージの機能で、'customer_id'を元に代理キー（サロゲートキー）を生成しています。
  これにより、元のIDに依存しない一意なキーを各顧客に付与できます。
*/

with source as (

    select * from {{ source('main', '注文') }}

),

renamed as (

    select
        "会員ID" as customer_id,
        {{ dbt_utils.generate_surrogate_key(['"会員ID"']) }} as customer_key

    from source

)

select * from renamed
