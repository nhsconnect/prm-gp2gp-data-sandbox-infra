resource "aws_s3_bucket" "notebook_data" {
  bucket = "prm-gp2gp-notebook-data-${var.environment}"
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

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name            = "${var.environment}-prm-gp2gp-notebook-data-s3-bucket"
      ApplicationRole = "AwsS3Bucket"
    }
  )
}

resource "aws_s3_bucket_public_access_block" "notebook_data_block" {
  bucket = aws_s3_bucket.notebook_data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_ssm_parameter" "read_only_buckets" {
  for_each = toset(var.read_only_bucket_params)
  name     = each.value
}
