#!/bin/bash

# Destruction de l'infrastructure Terraform

echo "Planning destruction..."
terraform plan -destroy -out=tfplan

echo "Destroying infrastructure..."
terraform apply tfplan