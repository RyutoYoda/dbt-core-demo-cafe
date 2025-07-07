/*
このモデルは、カフェの顧客データを扱うためのステージングモデルです。
- `source('main', '注文')` からデータを取得
- `dbt_utils.generate_surrogate_key` で一意キーを作成
*/

select
    "会員ID" as customer_id,
    {{ dbt_utils.generate_surrogate_key(['"会員ID"']) }} as customer_key
from {{ source('main', '注文') }}
