select 
    id as refund_id,
    *
from {{ var('refunds') }}