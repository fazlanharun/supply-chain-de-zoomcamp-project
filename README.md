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



## How to Replicate This Project

### 1. Prerequisites

* **AWS Account** with billing enabled.
* **Docker & Docker Compose** installed on your local machine.
* **Python 3.10+** (Recommended to use `uv` or `venv`).
* **Amazon Athena ODBC Driver** (Required for Power BI connectivity).

---

### 2. AWS Infrastructure Setup

1.  **Create S3 Buckets:**
    * `fazlan-supply-chain-lake-v3`: For storing **Bronze**, **Silver**, and **Gold** data layers.
    * `fazlan-athena-results-v3`: For storing **Athena query results**.
2.  **Configure Athena Workgroup:**
    * Navigate to **Athena > Workgroups > primary**.
    * Select **Edit** and set the **Query result location** to `s3://fazlan-athena-results-v3/`.
    * **CRITICAL:** Check the box **"Enforce workgroup configuration"**. This ensures Power BI and dbt can execute queries without location errors.
3.  **IAM Service Account:**
    * Create a user with `AmazonS3FullAccess`, `AmazonAthenaFullAccess`, and `AWSGlueConsoleFullAccess`.
    * Generate and save the **Access Key ID** and **Secret Access Key**.

---

### 3. Environment Configuration

Create a `.env` file in the root directory to store your credentials safely:

```bash
cp .env.example .env
# Open .env and fill in your AWS_ACCESS_KEY, AWS_SECRET_KEY, and BUCKET_NAME
