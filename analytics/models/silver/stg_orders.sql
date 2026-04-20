{{ 
  config(
    materialized='table',
    format='parquet',
    external_location='s3://fazlan-supply-chain-lake-v3/silver/orders/',
    s3_data_naming='schema_table'
  ) 
}}

SELECT
    -- Keys
    CAST(order_id AS INT) as order_id,
    CAST(customer_id AS INT) as customer_id,

    CAST(parse_datetime(order_date, 'MM/dd/yyyy HH:mm') AS TIMESTAMP) as order_timestamp,
    
    -- Metrics 
    CAST(order_item_total AS DECIMAL(10,2)) as total_sales,
    CAST(order_profit_per_order AS DECIMAL(10,2)) as profit,

    -- Dimensions 
    order_status,
    category_name,
    order_region,
    shipping_mode
FROM {{ source('external_source', 'bronze_orders') }}
WHERE order_id IS NOT NULL