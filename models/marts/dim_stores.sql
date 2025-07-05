/*
このモデルは、店舗に関するディメンションテーブルを作成します。
店舗の基本情報（店舗ID、店舗名、所在地、オープン日など）を提供します。

- `ref('stg_stores')`: ステージングモデルの店舗データを参照しています。
- `dbt_utils.generate_surrogate_key`: 'store_id'を元に店舗の代理キーを生成しています。
*/

with stores as (

    select * from {{ ref('stg_stores') }}

)

select
    {{ dbt_utils.generate_surrogate_key(['store_id']) }} as store_key,
    *
from stores
