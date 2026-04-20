import os
from datetime import datetime
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.amazon.aws.hooks.s3 import S3Hook

def upload_local_to_s3():
    # 1. Setup path
    local_file = "/opt/airflow/data/supply_chain_data.csv"
    s3_bucket = os.environ.get("S3_BUCKET_NAME")
    s3_key = "raw/supply_chain_data.csv"
    
    # 2. Check if file exists
    if not os.path.exists(local_file):
        raise FileNotFoundError(f"File is not found at: {local_file}")
    
    # 3. Upload to S3 (Logic: Local PC -> S3 Lake)
    s3_hook = S3Hook(aws_conn_id=None) # 
    print(f"Uploading {local_file} to s3://{s3_bucket}/{s3_key}")
    
    s3_hook.load_file(
        filename=local_file,
        key=s3_key,
        bucket_name=s3_bucket,
        replace=True
    )
    print("Upload complete!")

with DAG(
    dag_id="manual_to_s3_v1",
    start_date=datetime(2026, 1, 1),
    schedule_interval="@daily",
    catchup=False
) as dag:

    task_upload = PythonOperator(
        task_id="upload_csv_to_s3",
        python_callable=upload_local_to_s3
    )