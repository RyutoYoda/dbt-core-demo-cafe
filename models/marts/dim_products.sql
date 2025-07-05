/*
このモデルは、商品に関するディメンションテーブルを作成します。
商品の基本情報（商品ID、商品名、カテゴリ、価格など）を提供します。

- `ref('stg_products')`: ステージングモデルの商品データを参照しています。
- `dbt_utils.generate_surrogate_key`: 'product_id'を元に商品の代理キーを生成しています。
*/

with products as (

    select * from {{ ref('stg_products') }}

)

select
    {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,
    *
from products
