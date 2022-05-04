select
    id as order_id,
    created_at as created_at_timestamp,
    landing_site_ref as landing_site_base_url,
    cast({{ fivetran_utils.json_parse(string="customer", string_path=["id"]) }} as bigint) as customer_id,
    *
from {{ var('orders') }}