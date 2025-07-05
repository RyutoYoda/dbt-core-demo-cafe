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
