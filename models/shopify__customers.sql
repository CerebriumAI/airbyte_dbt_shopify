with customers as (
    select
        id as customer_id,
        first_name,
        last_name,
        email
    from {{ var('customers') }}
)

select * from customers
