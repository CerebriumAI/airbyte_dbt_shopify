with orders_line_items as (
    select
        order_line_item_id,
        product_id,
        variant_id,
        title,
        variant_title,
        sku,
        quantity,
        vendor,
        price,
        total_discount,
        _airbyte_orders_hashid
    from {{ ref('stg_shopify_orders_line_items') }}

),

orders as (
    select
        order_id,
        customer_id,
        currency,
        created_at_timestamp,
        _airbyte_orders_hashid
    from {{ ref('stg_shopify_orders') }}
),

final_order_items as (
    select
        orders_line_items.order_line_item_id,
        orders.order_id,
        orders_line_items.product_id,
        orders_line_items.variant_id,
        orders_line_items.title,
        orders_line_items.variant_title,
        orders_line_items.sku,
        orders_line_items.quantity,
        orders_line_items.vendor,
        orders_line_items.price,
        orders_line_items.total_discount,
        orders.currency,
        orders.created_at_timestamp
    from orders_line_items
    left join orders using (_airbyte_orders_hashid)
)

select *from final_order_items
