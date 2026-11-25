-- Customers ranked by highest total spending.
select
    c.customer_id,
    c.customer_name,
    c.region,
    count(distinct f.order_id) as total_orders,
    sum(f.quantity)            as total_units,
    sum(f.total_amount)        as total_spending,
    dense_rank() over (order by sum(f.total_amount) desc) as spending_rank
from {{ ref('fact_sales') }}   f
join {{ ref('dim_customer') }} c on f.customer_id = c.customer_id
group by all
order by total_spending desc, c.customer_id asc
