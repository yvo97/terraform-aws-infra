# Configuration du backend S3 pour l'environnement DEV
terraform {
  backend "s3" {
    bucket         = "infrodoctor-terraform-state-dev"  
    key            = "dev/terraform.tfstate"          
    region         = "us-east-1"
    dynamodb_table = "infrodoctor-terraform-state-lock-dev"       
    encrypt        = true
    use_lockfile   = true
  }
}