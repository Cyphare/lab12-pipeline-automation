-- Top 5 products per category by total revenue using ROW_NUMBER() and QUALIFY.
with product_sales as (
    select
        p.category,
        p.product_id,
        p.product_name,
        sum(f.quantity)     as units_sold,
        sum(f.total_amount) as revenue
    from {{ ref('fact_sales') }}  f
    join {{ ref('dim_product') }} p on f.product_id = p.product_id
    group by all
)
select
    category,
    product_id,
    product_name,
    units_sold,
    revenue,
    row_number() over (
        partition by category
        order by revenue desc, product_id asc
    ) as rank_in_category
from product_sales
qualify row_number() over (
    partition by category
    order by revenue desc, product_id asc
) <= 5
order by category, rank_in_category
