with refunds as (
    select
        refund_id,
        note,
        restock,
        user_id,
        order_id,
        shop_url,
        created_at_timestamp,
        processed_at_timestamp

    from {{ ref('stg_shopify_refunds') }}
),

orders as (
    select *
    from {{ ref('stg_shopify_orders') }}
),

customers as (
    select *
    from {{ ref('stg_shopify_customers') }}
),

final_refunds as (

    select
        refunds.refund_id,
        refunds.note,
        refunds.restock,
        refunds.user_id,
        refunds.order_id,
        refunds.shop_url,
        refunds.created_at_timestamp,
        refunds.processed_at_timestamp,
        customers.email,
        customers.first_name,
        customers.last_name,
        orders.total_price
    from refunds
    left join orders using(order_id)
    left join customers using(customer_id)

)


select * from final_refunds
