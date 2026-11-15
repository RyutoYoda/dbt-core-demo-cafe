{{ config(materialized='table') }}

with orders as (

    select * from {{ ref('stg_orders') }}

),

column_profiles as (

    select
        'stg_orders' as model_name,
        'order_id' as column_name,
        count(*) as row_count,
        sum(case when order_id is null then 1 else 0 end) as null_count
    from orders

    union all

    select
        'stg_orders',
        'customer_id',
        count(*),
        sum(case when customer_id is null then 1 else 0 end)
    from orders

    union all

    select
        'stg_orders',
        'store_id',
        count(*),
        sum(case when store_id is null then 1 else 0 end)
    from orders

    union all

    select
        'stg_orders',
        'ordered_at',
        count(*),
        sum(case when ordered_at is null then 1 else 0 end)
    from orders

    union all

    select
        'stg_orders',
        'order_method',
        count(*),
        sum(case when order_method is null then 1 else 0 end)
    from orders

    union all

    select
        'stg_orders',
        'satisfaction_level',
        count(*),
        sum(case when satisfaction_level is null then 1 else 0 end)
    from orders

    union all

    select
        'stg_orders',
        'usage_scenario',
        count(*),
        sum(case when usage_scenario is null then 1 else 0 end)
    from orders

)

select
    model_name,
    column_name,
    row_count,
    cast(null_count as bigint) as null_count,
    round(100.0 * null_count / nullif(row_count, 0), 2) as null_rate_pct
from column_profiles
