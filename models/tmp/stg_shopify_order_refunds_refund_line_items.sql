select
    _airbyte_order_refunds_hashid,
    subtotal
from {{ var('order_refunds_refund_line_items') }}
