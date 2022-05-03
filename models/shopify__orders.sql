with orders as (
    select
        id as order_id,
        email
    from {{ var('orders') }}
)

select * from orders
