with orders as (
    select
        order_id,
        customer_id,
        created_timestamp,
        total_line_items_price
        subtotal_price,
        total_discounts,
        total_price,
        currency,
        reffering_site,
        processing_method,
        landing_site_base_url,
        fulfillment_status
        _airbyte_orders_hashid
        
    from {{ ref('stg_shopify_orders_tmp') }}
),

orders_shipping_address as (
    select *
    from {{ ref('stg_shopify_orders_shipping_address_tmp') }}
), as (
    select *
    from {{ ref('stg_shopify_orders_shipping_address_tmp') }}
),

orders_shipping_lines as (
    select *
    from {{ ref('stg_shopify_orders_shipping_lines_tmp') }}
),

final_orders as (

    select
        *
    from orders
    left join orders_shipping_address on orders._airbyte_orders_hashid = orders_shipping_address._airbyte_orders_hashid
    left join orders_shipping_lines on orders._airbyte_orders_hashid = orders_shipping_lines._airbyte_orders_hashid

)


select * from final_orders
