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

  tags = merge(
    local.common_tags,
    {
      Name            = "${var.environment}-GP2GP-athena-results-s3-bucket"
      ApplicationRole = "AwsS3Bucket"
    }
  )
}

resource "aws_athena_workgroup" "athena_workgroup" {
  name = "prm-gp2gp-athena-workgroup-${var.environment}"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_results.bucket}/"
    }
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

resource "aws_glue_catalog_table" "mi_data_catalog_table" {
  name          = "gp2gp_mi"
  database_name = aws_glue_catalog_database.mi_data_catalog_database.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL = "TRUE"
  }

  storage_descriptor {
    location      = "s3://${data.aws_ssm_parameter.mi_data_bucket.value}/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

      parameters = {
        "field.delim"          = ","
        "serialization.format" = ","
      }
    }

    dynamic "columns" {
      for_each = range(1, 36)
      content {
        name = "col${columns.value}"
        type = "string"
      }
    }

  }
}

resource "aws_glue_catalog_table" "gp2gp_attachment_metadata" {
  name          = "gp2gp_attachment_metadata"
  database_name = aws_glue_catalog_database.mi_data_catalog_database.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL = "TRUE"
  }

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.data_sandbox.bucket}/attachment-insights/attachments-metadata/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"

      parameters = {
        "skip.header.line.count" = "1"
      }
    }

    columns {
      name = "time"
      type = "string"
    }

    columns {
      name = "attachment_id"
      type = "string"
    }

    columns {
      name = "conversation_id"
      type = "string"
    }

    columns {
      name = "from_system"
      type = "string"
    }

    columns {
      name = "to_system"
      type = "string"
    }

    columns {
      name = "attachment_type"
      type = "string"
    }

    columns {
      name = "compressed"
      type = "string"
    }

    columns {
      name = "content_type"
      type = "string"
    }

    columns {
      name = "large_attachment"
      type = "string"
    }

    columns {
      name = "length"
      type = "string"
    }

    columns {
      name = "original_base64"
      type = "string"
    }

    columns {
      name = "internal_id"
      type = "string"
    }

  }
}


resource "aws_glue_catalog_table" "gp2gp_attachment_messages" {
  name          = "gp2gp_attachment_messages"
  database_name = aws_glue_catalog_database.mi_data_catalog_database.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL = "TRUE"
  }

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.data_sandbox.bucket}/attachment-insights/gp2gp-messages/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"

      parameters = {
        "skip.header.line.count" = "1"
      }
    }

    columns {
      name = "time"
      type = "string"
    }

    columns {
      name = "conversation_id"
      type = "string"
    }

    columns {
      name = "internal_id"
      type = "string"
    }

    columns {
      name = "interaction_id"
      type = "string"
    }

  }
}
