with orders_line_items as (

    select *
    from {{ var('orders_line_items') }}

), products_variants as (

    select id as variant_id, *
    from {{ var('products_variants') }}

), refunds as (

    select *
    from {{ ref('shopify__orders__order_refunds') }}

), refunds_aggregated as (

    select
        sum(quantity) as quantity,
        sum(coalesce(subtotal, 0)) as subtotal
    from refunds

), joined as (

    select
    orders_line_items.*,

        products_variants.created_at as variant_created_at,
        products_variants.updated_at as variant_updated_at,
        products_variants.inventory_item_id,
        products_variants.image_id,
        products_variants.price as variant_price,
        products_variants.sku as variant_sku,
        products_variants.position as variant_position,
        products_variants.inventory_policy as variant_inventory_policy,
        products_variants.compare_at_price as variant_compare_at_price,
        products_variants.fulfillment_service as variant_fulfillment_service,
        products_variants.taxable as variant_is_taxable,
        products_variants.barcode as variant_barcode,
        products_variants.grams as variant_grams,
        products_variants.inventory_quantity as variant_inventory_quantity,
        products_variants.weight as variant_weight,
        products_variants.weight_unit as variant_weight_unit,
        products_variants.option1 as variant_option_1,
        products_variants.option2 as variant_option_2,
        products_variants.option3 as variant_option_3,
        products_variants.tax_code as variant_tax_code,
        products_variants.requires_shipping as variant_is_requiring_shipping
    from orders_line_items
    left join products_variants
        on products_variants.variant_id = orders_line_items.variant_id

)

select *
from joined
