/*
このモデルは、商品に関するディメンションテーブルを作成します。
商品の基本情報（商品ID、商品名、カテゴリ、価格など）を提供します。
*/

with products as (

    select * from {{ ref('stg_products') }}

)

select
    product_id as product_key,
    *
from products
