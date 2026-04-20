# Supply Chain End-to-End Data Pipeline (Medallion Architecture)

## Problem Statement
The current supply chain operational data is stored in disparate, raw CSV formats, making it difficult for stakeholders to analyze sales performance and operational efficiency in real-time. This project solves the "Invisibility in Operations" problem by implementing a structured Medallion Architecture. It transforms raw data into a high-performance Gold Layer (Analytics-ready), allowing business users to answer key questions:
-What is the monthly revenue trend? (Identifying seasonal growth)
-Which regions and product categories are most profitable? (Optimizing logistics)

## Architecture
Data Pipeline Flow:
Orchestration: Airflow (Dockerized) triggers the ingestion.
Ingestion: Python scripts fetch raw CSVs and land them in AWS S3 (Bronze Layer).
Schema Registry: AWS Glue Crawlers catalog the data.
Transformation: dbt running on Athena transforms data:
Bronze → Silver: Cleaning, casting types, and deduplication.
Silver → Gold: Aggregating metrics and Partitioning by month for performance.
Analytics: Power BI connects via ODBC to the Gold Layer.



How to Replicate This Project
1. Prerequisites
AWS Account (IAM User with AdministratorAccess for setup).
Docker & Docker Compose installed.
Python 3.10+ & uv or pip.
Power BI Desktop (for visualization).

2. Infrastructure Setup (AWS)
Create S3 Buckets:
fazlan-supply-chain-lake-v3 (Data Lake)
fazlan-athena-results-v3 (Athena Query Results)
IAM User: Generate Access Key ID and Secret Access Key.
Athena Workgroup: Ensure the primary workgroup has the "S3 Output Location" enforced to your results bucket.

3. Environment Configuration
Clone the repo and create a .env file:

Bash
git clone https://github.com/fazlanharun/supply-chain-de-project.git
cd supply-chain-de-project
cp .env.example .env
# Edit .env with your AWS Credentials
4. Run Orchestration (Airflow)
Spin up the Airflow environment:

Bash
docker-compose up -d
Access Airflow at localhost:8080.

Trigger the supply_chain_ingestion DAG to move data from Source to Bronze Layer.

5. dbt Transformation
Navigate to the analytics folder and execute models:

Bash
cd analytics
# Install dependencies
dbt deps
# Run models (Bronze -> Silver -> Gold)
dbt run
# Verify data quality
dbt test
Note: The Gold layer is partitioned by order_month. If this is your first run, dbt will automatically handle the partitioning in Athena.

6. Visualization (Power BI)
Install the Amazon Athena ODBC Driver.

Configure a System DSN named Athena_Fazlan.

Open the provided dashboard/supply_chain_overview.pbix (or create a new one).

Connect using the ODBC DSN to the gold_sales_performance table.
