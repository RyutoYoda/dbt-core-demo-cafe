/*
このモデルは、注文、注文明細、商品データを結合し、中間的なデータセットを作成します。
これにより、後続の分析モデルで必要な情報を一箇所に集約し、複雑な結合処理を避けることができます。

- `ref('stg_orders')`, `ref('stg_order_items')`, `ref('stg_products')`: dbtのref機能を使って、
  ステージングモデルで作成されたデータを参照しています。
- `left join`: 注文データに注文明細と商品データを結合しています。
- `total_price`: 数量と価格を乗算して、各注文明細の合計金額を計算しています。
*/

with orders as (

    select * from {{ ref('stg_orders') }}

),

order_items as (

    select * from {{ ref('stg_order_items') }}

),

products as (

    select * from {{ ref('stg_products') }}

),

order_items_joined as (

    select
        orders.order_id,
        orders.customer_id,
        orders.store_id,
        orders.ordered_at,
        orders.order_method,
        orders.satisfaction_level,
        orders.usage_scenario,
        order_items.product_id,
        order_items.quantity,
        products.price,
        order_items.quantity * products.price as total_price

    from orders
    left join order_items on orders.order_id = order_items.order_id
    left join products on order_items.product_id = products.product_id

)

select * from order_items_joined
