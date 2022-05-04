with products as (

    select
        product_id,
        title,
        product_type,
        vendor,
        created_at_timestamp
    from {{ ref('stg_shopify_products_tmp') }}

), 

orders_line_items as (

    select
        product_id,
        sum(quantity) as quantity_sold,
        max(created_at_timestamp) as most_recent_order_timestamp
        min(created_at_timestamp) as first_order_timestamp
    from {{ ref('shopify__order_line_items') }}

),

final_products as (
    select
        products.*
        order_line_items.quantity_sold,
        order_line_items.most_recent_order_timestamp,
        order_line_items.first_order_timestamp
    from products
    left join orders_line_items using (product_id)
)

select * from final_products
