select
    title as shipping_title,
    price as shipping_cost,
    *
from {{ var('orders_shipping_lines') }}