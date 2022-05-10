select
    id as refund_id,
    created_at as created_at_timestamp,
    processed_at as processed_at_timestamp,
    *
from {{ var('order_refunds') }}
