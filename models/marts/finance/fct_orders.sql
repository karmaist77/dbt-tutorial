with order_payments as (
    select
        order_id,
        sum (case when status = 'success' then amount end) as amount
    from {{ source('stripe', 'payment') }}
    group by 1
),

orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

final as (
    select
        orders.order_id,
        orders.customer_id,
        amount
    from orders

    left join order_payments using (order_id)
)

select * from final