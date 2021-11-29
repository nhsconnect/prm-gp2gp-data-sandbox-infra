resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "auto_shutoff" {
  name      = "auto-shutoff-lifecycle-config"
  on_start  = filebase64("./scripts/auto-stop-idle/on-start.sh")
}
