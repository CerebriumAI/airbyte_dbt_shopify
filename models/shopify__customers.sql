with customers as (

    select 
        customer_id,
    from {{ ref('stg_shopify_customers_tmp') }}

), 

orders as (

    select
        min(created_at_timestamp) as first_order_timestamp,
        max(created__at_timestamp) as most_recent_order_timestamp
    from {{ ref('stg_shopify_orders_tmp' )}}

), 

final_customers as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customers.email,
        customers.phone,
        customers.total_spent,
        customers.orders_count,
        customers.created_at_timestamp
    from customers
    left join orders using (customer_id)

)

select * from final_customers
