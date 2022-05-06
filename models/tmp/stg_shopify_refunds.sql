select
    id as refund_id,
    created_at as created_at_timestamp,
    *
from {{ var('refunds') }}
