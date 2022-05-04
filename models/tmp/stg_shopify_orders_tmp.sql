select
    id as order_id,
    created_at as created_timestamp,
    cast({{ fivetran_utils.json_parse(string="customer", string_path=["id"]) }} as bigint) as customer_id,
    *
from {{ var('orders') }}