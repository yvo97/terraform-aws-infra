# Configuration du backend S3 pour l'environnement PROD
terraform {
  backend "s3" {
    bucket         = "infrodoctor-terraform-state-prod"  
    key            = "prod/terraform.tfstate"         
    region         = "us-east-1"
    dynamodb_table = "infrodoctor-terraform-state-lock-prod"      
    encrypt        = true
    use_lockfile   = true
  }
}