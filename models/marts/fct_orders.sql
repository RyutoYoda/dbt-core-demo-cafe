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
