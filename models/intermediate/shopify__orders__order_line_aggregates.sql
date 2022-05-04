with orders_line_items as (

    select *
    from {{ var('orders_line_items') }}

), aggregated as (

    select
        _airbyte_orders_hashid,
        count(*) as line_item_count
    from orders_line_items
    group by 1

)

select *
from aggregated
