
provider "aws" {
  region = "ap-southeast-1" 
}


# 1. Database Definition
resource "aws_glue_catalog_database" "supply_chain_db" {
  name = "supply_chain_data_final"
}

# 2. S3 Bucket for Data Lake
resource "aws_s3_bucket" "data_lake" {
  bucket        = "fazlan-supply-chain-lake-v3"
  force_destroy = true
}

# 3. S3 Bucket for Athena Results
resource "aws_s3_bucket" "athena_results" {
  bucket        = "fazlan-athena-results-v3"
  force_destroy = true
}

# 4. Glue Table with Dynamic Columns
resource "aws_glue_catalog_table" "bronze_orders" {
  name          = "bronze_orders"
  database_name = aws_glue_catalog_database.supply_chain_db.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    "classification"         = "csv"
    "skip.header.line.count" = "1"
  }

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.data_lake.id}/raw/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "csv"
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters = {
        "separatorChar" = ","
        "quoteChar"     = "\""
        "escapeChar"    = "\\"
      }
    }

    dynamic "columns" {
      for_each = var.order_columns
      content {
        name = columns.value
        type = "string"
      }
    }
  }
}