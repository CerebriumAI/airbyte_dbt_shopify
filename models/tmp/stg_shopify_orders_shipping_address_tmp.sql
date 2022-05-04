select
    address1 as shipping_address_1,
    address2 as shipping_address_2,
    city as shipping_address_city,
    company as shipping_address_company,
    country as shipping_address_country,
    province as shipping_address_province,
    zip as shipping_address_zip,
    latitude as shipping_address_latitude,
    longitude as shipping_address_longitude,
    _airbyte_orders_hashid
from {{ var('orders_shipping_address') }}