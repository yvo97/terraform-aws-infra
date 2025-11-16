provider "aws" {
  region = var.aws_region
}

# Créer un bucket S3 pour chaque environnement
resource "aws_s3_bucket" "terraform_state" {
  for_each = toset(var.environments)

  bucket = "${var.project_name}-terraform-state-${each.value}"

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "terraform-state-${each.value}"
    Environment = each.value
    Project     = var.project_name
  }
}

# Versioning pour chaque bucket S3
resource "aws_s3_bucket_versioning" "terraform_state" {
  for_each = toset(var.environments)

  bucket = aws_s3_bucket.terraform_state[each.value].id

  versioning_configuration {
    status = "Enabled"
  }
}

# Chiffrement server-side pour chaque bucket S3
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  for_each = toset(var.environments)

  bucket = aws_s3_bucket.terraform_state[each.value].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Blocage de l'accès public
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  for_each = toset(var.environments)

  bucket = aws_s3_bucket.terraform_state[each.value].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Table DynamoDB pour le verrouillage du state
resource "aws_dynamodb_table" "terraform_state_lock" {
  for_each = toset(var.environments)

  name         = "${var.project_name}-terraform-state-lock-${each.value}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform-state-lock-${each.value}"
    Environment = each.value
    Project     = var.project_name
  }
}
