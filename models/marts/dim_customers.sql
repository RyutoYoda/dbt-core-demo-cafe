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
