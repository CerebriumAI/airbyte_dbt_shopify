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
        orders.total_price
    from refunds
    left join orders using(order_id)
)


select * from final_refunds
