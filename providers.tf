terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  # IMPORTANT: do NOT hard-code AWS credentials in Terraform files.
  # To make Terraform use the credentials file you created in WSL (~/.aws/credentials) choose one of:
  # - Run Terraform from WSL/Ubuntu where ~/.aws/credentials exists (Terraform will detect it automatically).
  # - Export the environment variable AWS_SHARED_CREDENTIALS_FILE to point to the WSL path from Windows, e.g.
  #     PowerShell: $env:AWS_SHARED_CREDENTIALS_FILE = '\\wsl$\\Ubuntu\\home\\<wsl_user>\\.aws\\credentials'
  # - Set AWS_PROFILE (var.aws_profile) to the profile name inside your credentials file (we already use it above).
  # - For CI, use secret variables or a secret manager (Vault, AWS Secrets Manager).
}