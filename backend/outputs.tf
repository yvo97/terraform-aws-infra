output "s3_bucket_names" {
  description = "Noms des buckets S3 créés pour le state Terraform"
  value       = { for env, bucket in aws_s3_bucket.terraform_state : env => bucket.bucket }
}

output "s3_bucket_arns" {
  description = "ARNs des buckets S3"
  value       = { for env, bucket in aws_s3_bucket.terraform_state : env => bucket.arn }
}

output "dynamodb_table_names" {
  description = "Noms des tables DynamoDB pour le state locking"
  value       = { for env, table in aws_dynamodb_table.terraform_state_lock : env => table.name }
}

output "dynamodb_table_arns" {
  description = "ARNs des tables DynamoDB"
  value       = { for env, table in aws_dynamodb_table.terraform_state_lock : env => table.arn }
}