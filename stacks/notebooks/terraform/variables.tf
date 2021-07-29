variable "region" {
  type        = string
  description = "AWS region."
  default     = "eu-west-2"
}

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

variable "data_sandbox_url" {
  type        = string
  description = "Git url of data sandbox repo"
}

variable "read_only_bucket_params" {
  type        = list(string)
  description = "List of ssm parameters containing buckets to which the notebooks have read only access"
}