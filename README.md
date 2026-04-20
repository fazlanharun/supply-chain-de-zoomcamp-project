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

### 2. AWS Access
  **IAM:**
    * Create IAM user with `AdministratorAccess`..
    * Generate and save the **Access Key ID** and **Secret Access Key**.

---

### 3. Environment Configuration

```bash
git clone https://github.com/fazlanharun/supply-chain-de-zoomcamp-project.git
cd supply-chain-de-zoomcamp-project
cp .env.example .env
# Open .env and fill in your AWS_ACCESS_KEY, AWS_SECRET_KEY, AWS_REGION, BUCKET_NAME.
```

### 4. Provision Infrastructure with Terraform
 ```bash
cd terraform
terraform init
terraform apply -auto-approve
```

### 5. Download data from Kaggle and extract zip file
 ```bash
cd ..
mkdir data
curl -L -o ~/Downloads/supply-chain-de-zoomcamp-project/data/dataco-smart-supply-chain-for-big-data-analysis.zip  https://www.kaggle.com/api/v1/datasets/download/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis
cd data
unzip dataco-smart-supply-chain-for-big-data-analysis.zip
mv DataCoSupplyChainDataset.csv supply_chain_data.csv
rm dataco-smart-supply-chain-for-big-data-analysis.zip
```

### 5. Ingest data using Airflow in Docker
 ```bash
cd ..
docker-compose up -d
Open Airflow UI at http://localhost:8082 (Default Credentials: admin / admin123).
Trigger the "manual_to_s3_v1" DAG manually.
Verify that raw supply_chain_data.csv files appear in your S3 fazlan-supply-chain-lake-v3/raw folder.
```

### 6. Tranform raw data in AWS using dbt in Docker. 
 ```bash
docker-compose exec dbt dbt debug
docker-compose exec dbt dbt run
```

### 7. Query silver, gold data in AWS using Amazon Athena
Open AWS Console, find service Athena.
Find database supply_chain_data_final that contain raw data.
Find database silver_db that contain silver and gold table named stg_orders,fct_sales_performance respectively.

Run simple query below to inspect the data:

```SQL
SELECT * FROM fct_sales_performance LIMIT 10;
```
### 8. Connecting to PowerBI
1.  **Configure Athena Workgroup:**
    * Navigate to **Athena > Workgroups > primary**.
    * Select **Edit** and set the **Query result location** to `s3://fazlan-athena-results-v3/`.
  
2. Download Amazon Athena OBDC Driver at https://docs.aws.amazon.com/athena/latest/ug/odbc-v2-driver.html. Install as usual.
3. Open ODBC. Ssystem DSN, choose Amazon Athena, Finish. In configuration pane. Give Data Source name eg (AWS Athena Fazlan). Region : ap-southeast-1.
4. Click authentication option at below. Authentication type : IAM Credentials. Usernama is AWS Access Key, Password is AWS Secret Key. Click ok.
5. Click test connection. It should display successfully connected to.

Successfully connected to: Athena engine version 3

Region: ap-southeast-1   
Catalog: AwsDataCatalog  
Workgroup: primary  
Auth Type: IAM Credentials  
Click ok,ok,ok to close the dialog box. 

6.Open PowerBI and Get Data -> ODBC -> Choose DSN that we created earlier eg (AWS Athena Fazlan). Click default or custom. 

7. You are successfully connected. You in the Powr BI get data pane with access to all three table, bronze_orders, stg_orders and fcst_sales_performance.

8. fcst_sales_performance is the table used to create the PowerBI dashboard.


