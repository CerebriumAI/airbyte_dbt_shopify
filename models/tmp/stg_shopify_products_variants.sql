select
    id as variant_id,
    created_at as created_at_timestamp,
    updated_at as variant_updated_at,
    *
from {{ var('products_variants') }}
