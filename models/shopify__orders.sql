with orders as (
    select
        order_id,
        customer_id,
        created_at_timestamp,
        total_line_items_price,
        subtotal_price,
        total_discounts,
        total_price,
        currency,
        referring_site,
        processing_method,
        landing_site_base_url,
        fulfillment_status,
        _airbyte_orders_hashid

    from {{ ref('stg_shopify_orders') }}
),

orders_shipping_address as (
    select *
    from {{ ref('stg_shopify_orders_shipping_address') }}
),

orders_shipping_lines as (
    select *
    from {{ ref('stg_shopify_orders_shipping_lines') }}
),

final_orders as (

    select
        orders.order_id,
        orders.customer_id,
        orders.created_at_timestamp,
        orders.total_line_items_price,
        orders.subtotal_price,
        orders.total_discounts,
        orders.total_price,
        orders.currency,
        orders.referring_site,
        orders.processing_method,
        orders.landing_site_base_url,
        orders.fulfillment_status,
        orders_shipping_address.shipping_address_1,
        orders_shipping_address.shipping_address_2,
        orders_shipping_address.shipping_address_city,
        orders_shipping_address.shipping_address_company,
        orders_shipping_address.shipping_address_country,
        orders_shipping_address.shipping_address_province,
        orders_shipping_address.shipping_address_zip,
        orders_shipping_address.shipping_address_latitude,
        orders_shipping_address.shipping_address_longitude,
        orders_shipping_lines.shipping_title,
        orders_shipping_lines.shipping_cost
    from orders
    left join orders_shipping_address using(_airbyte_orders_hashid)
    left join orders_shipping_lines using(_airbyte_orders_hashid)

)


select * from final_orders
