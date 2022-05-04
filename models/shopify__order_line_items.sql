with orders_line_items as (

    select *
    from {{ var('orders_line_items') }}

), products_variants as (

    select *
    from {{ var('products_variants') }}

), refunds as (

    select *
    from {{ ref('shopify__orders__order_refunds') }}

), refunds_aggregated as (

    select
        order_line_id,
        sum(quantity) as quantity,
        sum(coalesce(subtotal, 0)) as subtotal
    from refunds
    group by 1

), joined as (

    select
    orders_line_items.*,

        coalesce(refunds_aggregated.quantity,0) as refunded_quantity,
        coalesce(refunds_aggregated.subtotal,0) as refunded_subtotal,
    orders_line_items.quantity - coalesce(refunds_aggregated.quantity,0) as quantity_net_refunds,
    orders_line_items.pre_tax_price  - coalesce(refunds_aggregated.subtotal,0) as subtotal_net_refunds,

        products_variants.created_timestamp as variant_created_at,
        products_variants.updated_timestamp as variant_updated_at,
        products_variants.inventory_item_id,
        products_variants.image_id,
        products_variants.title as variant_title,
        products_variants.price as variant_price,
        products_variants.sku as variant_sku,
        products_variants.position as variant_position,
        products_variants.inventory_policy as variant_inventory_policy,
        products_variants.compare_at_price as variant_compare_at_price,
        products_variants.fulfillment_service as variant_fulfillment_service,
        products_variants.inventory_management as variant_inventory_management,
        products_variants.is_taxable as variant_is_taxable,
        products_variants.barcode as variant_barcode,
        products_variants.grams as variant_grams,
        products_variants.inventory_quantity as variant_inventory_quantity,
        products_variants.weight as variant_weight,
        products_variants.weight_unit as variant_weight_unit,
        products_variants.option_1 as variant_option_1,
        products_variants.option_2 as variant_option_2,
        products_variants.option_3 as variant_option_3,
        products_variants.tax_code as variant_tax_code,
        products_variants.is_requiring_shipping as variant_is_requiring_shipping
    from orders_line_items
    left join refunds_aggregated
        on refunds_aggregated.order_line_id = orders_line_items.order_line_id
    left join products_variants
        on products_variants.variant_id = orders_line_items.variant_id

)

select *
from joined
