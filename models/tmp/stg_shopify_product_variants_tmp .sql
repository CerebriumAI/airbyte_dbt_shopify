select
    id as variant_id, 
    *
    from {{ var('products_variants') }}