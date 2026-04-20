# Supply Chain Data Pipeline (Medallion Architecture)

## Problem Statement
The current supply chain operational data is stored in disparate, raw CSV formats, making it difficult for stakeholders to analyze sales performance and operational efficiency in real-time. This project solves the "Invisibility in Operations" problem by transforming raw data into a high-performance Gold Layer.

## Architecture
- **Orchestration:** Airflow (Dockerized)
- **Data Lake:** AWS S3
- **Data Warehouse:** AWS Glue & Athena
- **Transformation:** dbt (partitioned by month)
- **Visualization:** Power BI (ODBC Connection)

## How to Run
1. Clone repo.
2. `docker-compose up -d` for Airflow.
3. Run Airflow DAG to ingest data.
4. Go to `analytics/` folder, run `dbt deps` then `dbt run`.