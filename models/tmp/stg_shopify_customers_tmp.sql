select 
    id as customer_id,
    * 
from {{ var('customers') }}