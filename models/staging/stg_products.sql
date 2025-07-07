/*
このモデルは、商品マスタデータを扱うためのステージングモデルです。

- `source('main', '商品マスタ')`: 'main'スキーマにある'商品マスタ'テーブルを参照しています。
- カラム名の変更: 日本語のカラム名を英語にリネームしています。
*/

select
    "商品ID" as product_id,
    "商品名" as product_name,
    "カテゴリ" as category,
    "価格" as price,
    "カスタマイズ有無" as is_customizable

from {{ source('main', '商品マスタ') }}

