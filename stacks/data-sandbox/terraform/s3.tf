resource "aws_s3_bucket" "data_sandbox" {
  bucket = "prm-gp2gp-data-sandbox-${var.environment}"
  acl = "private"

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

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(
    local.common_tags, {
      Name            = "${var.environment}-prm-gp2gp-data-sandbox-s3-bucket"
      ApplicationRole = "AwsS3Bucket"
    }
  )
}

resource "aws_s3_bucket_public_access_block" "data_sandbox_block" {
  bucket = aws_s3_bucket.data_sandbox.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_ssm_parameter" "mi_data_bucket" {
  name = var.mi_data_bucket_ssm_param_name
}