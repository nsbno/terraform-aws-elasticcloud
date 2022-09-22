resource "aws_ssm_parameter" "elastic_cloud_password" {
  name      = "/${var.name_prefix}/config/elastic-cloud-password"
  type      = "SecureString"
  value     = "latest"
  lifecycle {
    ignore_changes = [value]
  }
}

module "elastic_cloud" {
  source            = "github.com/nsbno/terraform-aws-elasticcloud.git?ref=<COMMIT_HASH>"
  name_prefix       = var.name_prefix
  ssm_name_password = aws_ssm_parameter.elastic_cloud_password.name
  hostname          = var.elastic_cloud_hostname
  port              = "9243"
  username          = var.elastic_cloud_username
  index             = "${var.name_prefix}-${var.application_name}"
  tags              = var.tags
}