resource "aws_s3_bucket" "data_sandbox" {
  bucket = "prm-gp2gp-data-sandbox-${var.environment}"
  acl    = "private"

  # To protect again accidental data loss
  versioning {
    enabled = true
  }

  # To cleanup old data eventually
  lifecycle_rule {
    enabled = true

    noncurrent_version_expiration {
      days = 60
    }
  }

  tags = {
    Name        = "GP2GP data sandbox"
    CreatedBy   = var.repo_name
    Environment = var.environment
    Team        = var.team
  }
}

resource "aws_s3_bucket_public_access_block" "data_sandbox_block" {
  bucket = aws_s3_bucket.data_sandbox.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}