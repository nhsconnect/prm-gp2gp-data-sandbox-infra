resource "aws_s3_bucket" "athena_results" {
  bucket = "prm-gp2gp-athena-results-${var.environment}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "GP2GP athena results"
    CreatedBy   = var.repo_name
    Environment = var.environment
    Team        = var.team
  }


}

resource "aws_s3_bucket_public_access_block" "athena_results_block" {
  bucket = aws_s3_bucket.athena_results.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_glue_catalog_database" "mi_data_catalog_database" {
  name = "prm-gp2gp-mi-data-sandbox-${var.environment}"
}