variable "environment" {
  type        = string
  description = "Uniquely identifies each deployment, i.e. dev, prod."
}

variable "team" {
  type        = string
  default     = "Registrations"
  description = "Team owning this resource"
}

variable "repo_name" {
  type        = string
  default     = "prm-gp2gp-data-sandbox-infra"
  description = "Name of this repository"
}

variable "region" {
  type        = string
  description = "AWS region."
  default     = "eu-west-2"
}

variable "mi_data_bucket_ssm_param_name" {
  type        = string
  description = "Name of SSM parameter containing MI data bucket name"
}