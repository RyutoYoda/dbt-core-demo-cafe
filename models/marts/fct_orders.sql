/*
このモデルは、注文に関するファクトテーブルを作成します。
各注文の合計金額、合計数量、顧客満足度、利用シーンなどの情報を提供します。

- `ref('int_order_items_joined')`: 中間モデルの結合済み注文明細データを参照しています。
- `dbt_utils.generate_surrogate_key`: 'order_id', 'customer_id', 'store_id'を元にそれぞれの代理キーを生成しています。
- `sum(total_price) as total_price`: 各注文の合計金額を計算しています。
- `sum(quantity) as total_quantity`: 各注文の合計数量を計算しています。
- `max(satisfaction_level)`, `max(usage_scenario)`, `max(order_method)`: グループ化された注文の満足度、利用シーン、注文方法を取得しています。
  これらのカラムは注文ごとに一意であるため、max関数を使用しても問題ありません。
*/

with order_items as (

    select * from {{ ref('int_order_items_joined') }}

),

fct_orders as (

    select
        {{ dbt_utils.generate_surrogate_key(['order_id']) }} as order_key,
        {{ dbt_utils.generate_surrogate_key(['customer_id']) }} as customer_key,
        {{ dbt_utils.generate_surrogate_key(['store_id']) }} as store_key,
        ordered_at,
        sum(total_price) as total_price,
        sum(quantity) as total_quantity,
        max(satisfaction_level) as satisfaction_level,
        max(usage_scenario) as usage_scenario,
        max(order_method) as order_method

    from order_items
    group by order_id, customer_id, store_id, ordered_at

)

select * from fct_orders
