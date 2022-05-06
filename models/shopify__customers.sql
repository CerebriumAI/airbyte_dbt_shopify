with customers as (

    select
        customer_id,
        first_name,
        last_name,
        email,
        phone,
        total_spent,
        orders_count,
        created_at_timestamp,
        _airbyte_customers_hashid
    from {{ ref('stg_shopify_customers') }}

),

orders as (

    select
        customer_id,
        min(created_at_timestamp) as first_order_timestamp,
        max(created_at_timestamp) as most_recent_order_timestamp
    from {{ ref('stg_shopify_orders' )}}
    group by 1

),

customers_default_address as (
    select
        _airbyte_customers_hashid,
        city,
        country,
        phone,
        province,
        name,
        company
    from {{ ref('stg_shopify_customers_default_address') }})
,

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
        customers_default_address.city,
        customers_default_address.country,
        orders.first_order_timestamp,
        orders.most_recent_order_timestamp
    from customers
    left join orders using (customer_id)
    left join customers_default_address using (_airbyte_customers_hashid)

)

select * from final_customers
