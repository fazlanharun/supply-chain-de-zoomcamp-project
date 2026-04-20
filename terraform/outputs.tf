output "glue_table_name" {
  value = aws_glue_catalog_table.bronze_orders.name
}

output "data_lake_bucket" {
  value = aws_s3_bucket.data_lake.id
}