select
    title as shipping_title,
    price as shipping_cost,
    *
from {{ var('order_shipping_lines') }}