#!/bin/bash

set -e

echo "Initialisation du backend S3 pour Terraform..."

# Vérifications préalables
if ! command -v terraform &> /dev/null; then
    echo "Terraform n'est pas installé"
    exit 1
fi

if ! command -v aws &> /dev/null; then
    echo "AWS CLI n'est pas installé"
    exit 1
fi

# Variables configurables
S3_BUCKET_NAME="terraform-state-${RANDOM}-${RANDOM}"
DYNAMODB_TABLE_NAME="terraform-state-lock"
AWS_REGION="us-east-1"

echo "Création du backend S3..."
echo "Bucket S3: $S3_BUCKET_NAME"
echo "Table DynamoDB: $DYNAMODB_TABLE_NAME"
echo "Région: $AWS_REGION"

# Créer le backend S3 et DynamoDB
cd backend

# Initialiser le module backend
terraform init

# Appliquer la configuration du backend
terraform apply -auto-approve \
  -var="s3_bucket_name=$S3_BUCKET_NAME" \
  -var="dynamodb_table_name=$DYNAMODB_TABLE_NAME" \
  -var="aws_region=$AWS_REGION"

# Récupérer les outputs
BACKEND_BUCKET=$(terraform output -raw s3_bucket_name)
BACKEND_TABLE=$(terraform output -raw dynamodb_table_name)

cd ..

# Mettre à jour la configuration backend
cat > backend.tf << EOF
terraform {
  backend "s3" {
    bucket         = "$BACKEND_BUCKET"
    key            = "terraform.tfstate"
    region         = "$AWS_REGION"
    dynamodb_table = "$BACKEND_TABLE"
    encrypt        = true
  }
}
EOF

echo "Backend S3 configuré avec succès!"
echo "Détails:"
echo "   - Bucket S3: $BACKEND_BUCKET"
echo "   - Table DynamoDB: $BACKEND_TABLE"
echo "   - Région: $AWS_REGION"

# Initialiser Terraform avec le nouveau backend
echo "Initialisation de Terraform avec le backend S3..."
terraform init -migrate-state

echo "Configuration terminée! ."