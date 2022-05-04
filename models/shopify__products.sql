with products as (

    select id as product_id, *
    from {{ var('products') }}

), orders_line_items as (

    select *
    from {{ ref('shopify__order_line_items') }}

), orders as (

    select *
    from {{ ref('shopify__orders')}}

), order_lines_aggregated as (

    select
        orders_line_items.product_id,
        sum(orders_line_items.quantity) as quantity_sold,
        sum(orders_line_items.pre_tax_price) as subtotal_sold,

        min(orders.created_timestamp) as first_order_timestamp,
        max(orders.created_timestamp) as most_recent_order_timestamp
    from orders_line_items
    left join orders
        using (_airbyte_orders_hashid)
    group by 1

), joined as (

    select
        products.*,
        coalesce(order_lines_aggregated.quantity_sold,0) as quantity_sold,
        coalesce(order_lines_aggregated.subtotal_sold,0) as subtotal_sold,

        order_lines_aggregated.first_order_timestamp,
        order_lines_aggregated.most_recent_order_timestamp
    from products
    left join order_lines_aggregated
        using (product_id)

)

select *
from joined
