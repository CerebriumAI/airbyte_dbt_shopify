select 
    id as order_line_item_id,
    *
from {{ var('orders_line_items') }}