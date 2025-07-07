/*
このモデルは、注文明細データを扱うためのステージングモデルです。

- `source('main', '注文明細')`: 'main'スキーマにある'注文明細'テーブルを参照しています。
- カラム名の変更: 日本語のカラム名を英語にリネームしています。これにより、後続のモデルでの利用が容易になります。
*/

select
    "注文明細ID" as order_item_id,
    "注文ID" as order_id,
    "商品ID" as product_id,
    "数量" as quantity
from {{ source('main', '注文明細') }}
