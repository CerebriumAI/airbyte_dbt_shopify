with refunds as (

    select id as refund_id, *
    from {{ var('refunds') }}

), order_refunds_refund_line_items as (

    select *
    from {{ var('order_refunds_refund_line_items') }}

), refund_join as (

    select
        refunds.refund_id,
        refunds.created_at,
        refunds.order_id,
        refunds.user_id,
        order_refunds_refund_line_items._airbyte_order_refunds_hashid,
        order_refunds_refund_line_items.line_item_id,
        order_refunds_refund_line_items.restock_type,
        order_refunds_refund_line_items.quantity,
        order_refunds_refund_line_items.subtotal,
        order_refunds_refund_line_items.total_tax
    from refunds
    left join order_refunds_refund_line_items
        on refunds._airbyte_order_refunds_hashid = order_refunds_refund_line_items._airbyte_order_refunds_hashid

)

select *
from refund_join
