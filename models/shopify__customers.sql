with customers as (

    select 
        customer_id,
        first_name,
        last_name,
        email,
        phone,
        total_spent,
        orders_count,
        created_at_timestamp
    from {{ ref('stg_shopify_customers_tmp') }}

), 

orders as (

    select
        customer_id,
        min(created_at_timestamp) as first_order_timestamp,
        max(created_at_timestamp) as most_recent_order_timestamp
    from {{ ref('stg_shopify_orders_tmp' )}}
    group by 1

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
        customers.created_at_timestamp,
        orders.first_order_timestamp,
        orders.most_recent_order_timestamp
    from customers
    left join orders using (customer_id)

)

select * from final_customers
