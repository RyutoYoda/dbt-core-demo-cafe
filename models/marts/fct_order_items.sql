/*
このモデルは、「注文明細」を粒度とするファクトテーブルを作成します。
各行が、一つの注文に含まれる特定の商品明細を表します。
商品レベルの詳細な分析（例：カテゴリ別売上、商品別販売数量）を可能にすることが目的です。

- `ref('int_order_items_joined')`: 注文、注文明細、商品を結合した中間モデルをベースにします。
- `dbt_utils.generate_surrogate_key`: 各ディメンションへの結合キー（サロゲートキー）と、このテーブル自体の主キーを生成します。
*/

with order_items as (

    select * from {{ ref('int_order_items_joined') }}

)

select
    -- 主キー
    {{ dbt_utils.generate_surrogate_key(['order_id', 'product_id']) }} as order_item_key,

    -- 代理キー (ディメンションへの結合用)
    {{ dbt_utils.generate_surrogate_key(['order_id']) }} as order_key,
    {{ dbt_utils.generate_surrogate_key(['customer_id']) }} as customer_key,
    {{ dbt_utils.generate_surrogate_key(['store_id']) }} as store_key,
    {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,

    -- 劣化したディメンション (Degenerate Dimension)
    ordered_at,

    -- メジャー (事実)
    quantity,
    total_price as line_item_total_price

from order_items
