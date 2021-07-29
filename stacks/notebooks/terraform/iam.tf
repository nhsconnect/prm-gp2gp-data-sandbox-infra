data "aws_iam_policy_document" "sagemaker_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "sagemaker.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "notebook" {
  name               = "${var.environment}-gp2gp-sagemaker-sandbox"
  description        = "Sagemaker role for exploring GP2GP data sandbox"
  assume_role_policy = data.aws_iam_policy_document.sagemaker_assume.json
}

resource "aws_iam_role_policy_attachment" "notebook_sagemaker" {
  role       = aws_iam_role.notebook.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role_policy_attachment" "notebook_bucket_access" {
  role       = aws_iam_role.notebook.name
  policy_arn = aws_iam_policy.sandbox_bucket_access.arn
}

resource "aws_iam_role_policy_attachment" "data_pipeline_buckets_read_only_access" {
  role       = aws_iam_role.notebook.name
  policy_arn = aws_iam_policy.data_pipeline_buckets_read_only_access.arn
}

resource "aws_iam_policy" "sandbox_bucket_access" {
  name   = "${var.environment}-sandbox-bucket-access"
  policy = data.aws_iam_policy_document.sandbox_bucket_access.json
}

data "aws_iam_policy_document" "sandbox_bucket_access" {
  statement {
    sid = "ListBucket"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.notebook_data.bucket}",
    ]
  }

  statement {
    sid = "ReadWriteObjects"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.notebook_data.bucket}/*",
    ]
  }
}

resource "aws_iam_policy" "data_pipeline_buckets_read_only_access" {
  name   = "${var.environment}-data-pipeline-buckets-read-only-access"
  policy = data.aws_iam_policy_document.data_pipeline_buckets_read_only_access.json
}

data "aws_iam_policy_document" "data_pipeline_buckets_read_only_access" {
  statement {
    sid = "ListBucket"

    actions = [
      "s3:ListBucket",
    ]

    resources = [for params in data.aws_ssm_parameter.read_only_buckets : "arn:aws:s3:::${params.value}"]
  }

  statement {
    sid = "ReadObjects"

    actions = [
      "s3:GetObject",
    ]

    resources = [for params in data.aws_ssm_parameter.read_only_buckets : "arn:aws:s3:::${params.value}/*"]

  }
}
