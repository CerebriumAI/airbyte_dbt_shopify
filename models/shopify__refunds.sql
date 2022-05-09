with refunds as (
    select
        refund_id,
        note,
        restock,
        user_id,
        order_id,
        shop_url,
        created_at_timestamp,
        processed_at_timestamp,
        _airbyte_order_refunds_hashid

    from {{ ref('stg_shopify_order_refunds') }}
),

order_refunds_refund_line_items as (
    select
        _airbyte_order_refunds_hashid,
        sum(subtotal) as total_refund_amount
    from {{ ref('stg_shopify_order_refunds_refund_line_items') }}
    group by _airbyte_order_refunds_hashid
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
        order_refunds_refund_line_items.total_refund_amount
    from refunds
    left join order_refunds_refund_line_items using(_airbyte_order_refunds_hashid)
)


select * from final_refunds
