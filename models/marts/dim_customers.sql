/*
このモデルは、顧客に関するディメンションテーブルを作成します。
顧客の初回注文日、最終注文日、注文回数などの集計情報を提供します。

- `ref('stg_orders')`: ステージングモデルの注文データを参照しています。
- `dbt_utils.generate_surrogate_key`: 'customer_id'を元に顧客の代理キーを生成しています。
- `min(ordered_at) as first_order_at`: 顧客ごとの初回注文日を計算しています。
- `max(ordered_at) as last_order_at`: 顧客ごとの最終注文日を計算しています。
- `count(distinct order_id) as number_of_orders`: 顧客ごとのユニークな注文数を計算しています。
*/

with orders as (

    select * from {{ ref('stg_orders') }}

),

customer_summary as (

    select
        {{ dbt_utils.generate_surrogate_key(['customer_id']) }} as customer_key,
        customer_id,
        min(ordered_at) as first_order_at,
        max(ordered_at) as last_order_at,
        count(distinct order_id) as number_of_orders

    from orders
    group by customer_id

)

select * from customer_summary
