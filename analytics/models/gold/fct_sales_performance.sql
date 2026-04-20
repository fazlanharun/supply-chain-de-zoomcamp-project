{{ config(
    materialized='table',
    format='parquet',
    external_location='s3://fazlan-supply-chain-lake-v3/gold/sales_performance/',
    partitioned_by=['order_month'],
    s3_data_naming='schema_table'
) }}

SELECT
    category_name,
    order_region,
    count(distinct order_id) as total_orders,
    sum(total_sales) as total_revenue,
    sum(profit) as total_profit,
    -- Profit Margin (Profit / Sales)
    round(sum(profit) / nullif(sum(total_sales), 0), 4) as profit_margin,
    date_trunc('month', order_timestamp) as order_month

FROM {{ ref('stg_orders') }} --
GROUP BY 1, 2, 7
ORDER BY order_month DESC, total_revenue DESC