with product_variants as (

    select
        variant_id,
        title,
        sku,
        price,
        inventory_quantity,
        _airbyte_products_hashid
    from {{ ref('stg_shopify_products_variants_tmp') }}

), 

products as (

    select *
    from {{ ref('stg_shopify_products_tmp') }}

), 

product_variants_final as (

    select
        product_variants.variant_id,
        products.product_id,
        product_variants.title,
        product_variants.sku,
        product_variants.price,
        product_variants.inventory_quantity
    from product_variants
    left join products using (_airbyte_products_hashid)

)

select * from product_variants_final
