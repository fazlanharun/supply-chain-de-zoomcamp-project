# Supply Chain End-to-End Data Pipeline (Medallion Architecture)

## 🎯 Problem Statement
The current supply chain operational data is stored in disparate, raw CSV formats, making it difficult for stakeholders to analyze sales performance and operational efficiency in real-time. 

This project solves the **"Invisibility in Operations"** problem by implementing a structured **Medallion Architecture**. It transforms raw data into a high-performance **Gold Layer** (Analytics-ready), allowing business users to answer key questions:

* **What is the monthly revenue trend?** (Identifying seasonal growth)
* **Which regions and product categories are most profitable?** (Optimizing logistics)

---

## 🏗️ Architecture

### Data Pipeline Flow
1.  **Orchestration:** **Airflow (Dockerized)** triggers the ingestion.
2.  **Ingestion:** Python scripts fetch raw CSVs and land them in **AWS S3 (Bronze Layer)**.
3.  **Schema Registry:** **AWS Glue Crawlers** catalog the data.
4.  **Transformation:** **dbt** running on **Athena** transforms data:
    * **Bronze → Silver:** Cleaning, casting types, and deduplication.
    * **Silver → Gold:** Aggregating metrics and **Partitioning by month** for performance.
5.  **Analytics:** **Power BI** connects via **ODBC** to the Gold Layer.

---

## 🛠️ Tech Stack

| Layer | Tool | Purpose |
| :--- | :--- | :--- |
| **Cloud Provider** | AWS | Hosting Infrastructure |
| **Orchestration** | Apache Airflow | Workflow Scheduling |
| **Data Lake** | AWS S3 | Storage (Bronze, Silver, Gold) |
| **Data Warehouse** | AWS Athena | Serverless Query Engine |
| **Cataloging** | AWS Glue | Metadata & Schema Registry |
| **Transformation** | dbt | SQL Modeling & Lineage |
| **Visualization** | Power BI | Business Intelligence Dashboard |

---

## 📂 Medallion Layers Logic

### 🥉 Bronze Layer
* **Source:** Raw CSV files.
* **State:** Original, unaltered data.
* **Format:** CSV.

### 🥈 Silver Layer
* **Process:** Handled by dbt staging models.
* **Cleanup:** Data type casting  for consistency.
* **Format:** Parquet.

### 🥇 Gold Layer
* **Process:** Handled by dbt models.
* **Logic:** Aggregated sales metrics (Total Revenue, Profit Margin).
* **Optimization:** **Partitioned by `order_month`** to reduce Athena scan costs and improve BI performance.
* **Format:** Parquet.

---

## 📊 Dashboard Insights
* **Tile 1 (Monthly Revenue):** Time-series analysis to monitor business growth.
* **Tile 2 (Profitability Matrix):** Bar chart identifying high-margin categories and regions.

<img width="1306" height="815" alt="supply chain de" src="https://github.com/user-attachments/assets/f9a2ae18-861f-46b6-8926-241da5c7b452" />


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
3.  **IAM:**
    * Create IAM user with `AdministratorAccess`..
    * Generate and save the **Access Key ID** and **Secret Access Key**.

---

### 3. Environment Configuration

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your AWS region and unique bucket names
terraform init
terraform apply -auto-approve
cd ..

Create a `.env` file in the root directory to store your credentials safely:

```bash
cp .env.example .env
# Open .env and fill in your AWS_ACCESS_KEY, AWS_SECRET_KEY, AWS_REGION, BUCKET_NAME.

### . Provision Infrastructure with Terraform
 
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your AWS region and unique bucket names
terraform init
terraform apply -auto-approve
cd ..

docker-compose up -d
Open Airflow UI at http://localhost:8080 (Default Credentials: airflow / airflow).

Trigger the supply_chain_ingestion DAG manually.

Verify that raw .csv files appear in your S3 Bronze folder.

