select
    id as product_id,
    created_at as created_at_timestamp,
    *
from {{ var('products') }}    