with orders as (

    select *
    from {{ ref('shopify__orders') }}

), transactions as (

    select *
    from {{ ref('shopify__transactions' )}}
    where lower(status) = 'success'

), aggregated as (

    select
        customer_id,
        min(orders.created_timestamp) as first_order_timestamp,
        max(orders.created_timestamp) as most_recent_order_timestamp,
        avg(case when lower(transactions.kind) in ('sale','capture') then transactions.currency_exchange_calculated_amount end) as average_order_value,
        sum(case when lower(transactions.kind) in ('sale','capture') then transactions.currency_exchange_calculated_amount end) as lifetime_total_spent,
        sum(case when lower(transactions.kind) in ('refund') then transactions.currency_exchange_calculated_amount end) as lifetime_total_refunded,
        count(distinct orders.order_id) as lifetime_count_orders
    from orders
             left join transactions
                       using (order_id)
    where customer_id is not null
    group by 1

)

select *
from aggregated
