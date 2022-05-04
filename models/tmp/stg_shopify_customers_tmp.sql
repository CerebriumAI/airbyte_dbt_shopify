select 
    id as customer_id,
    created_at as created_at_timestamp,
    * 
from {{ var('customers') }}