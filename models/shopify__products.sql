with products as (

    select *
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

        sum(orders_line_items.quantity_net_refunds) as quantity_sold_net_refunds,
        sum(orders_line_items.subtotal_net_refunds) as subtotal_sold_net_refunds,

        min(orders.created_timestamp) as first_order_timestamp,
        max(orders.created_timestamp) as most_recent_order_timestamp
    from orders_line_items
    left join orders
        using (order_id)
    group by 1

), joined as (

    select
        products.*,
        coalesce(order_lines_aggregated.quantity_sold,0) as quantity_sold,
        coalesce(order_lines_aggregated.subtotal_sold,0) as subtotal_sold,

        {% if fivetran_utils.enabled_vars(vars=["shopify__using_order_line_refund", "shopify__using_refund"]) %}
        coalesce(order_lines_aggregated.quantity_sold_net_refunds,0) as quantity_sold_net_refunds,
        coalesce(order_lines_aggregated.subtotal_sold_net_refunds,0) as subtotal_sold_net_refunds,
        {% endif %}

        order_lines_aggregated.first_order_timestamp,
        order_lines_aggregated.most_recent_order_timestamp
    from products
    left join order_lines_aggregated
        using (product_id)

)

select *
from joined
