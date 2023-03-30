resource "aws_sagemaker_code_repository" "prm_gp2gp_data_sandbox" {
  code_repository_name = "prm-gp2gp-data-sandbox"

  git_config {
    repository_url = var.data_sandbox_url
  }
}
