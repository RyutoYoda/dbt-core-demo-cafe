select
    order_item_key,
    quantity,
    line_item_total_price
from {{ ref('fct_order_items') }}
where quantity is null
   or quantity <= 0
   or line_item_total_price is null
   or line_item_total_price < 0
