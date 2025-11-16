# Configuration du backend S3 pour Terraform
terraform {
  backend "s3" {
    bucket         = "yvo-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
    
  }
}