data "aws_region" "current" {}

data "aws_ssm_parameter" "password" {
  name = var.ssm_name_password
}

data "archive_file" "logforwardingelastic" {
  output_path = "Logforwarding.zip"
  source_file = "${path.module}/src/Logforwarding.js"
  type        = "zip"
}

# Lambda resources
resource "aws_lambda_function" "logs_to_elasticsearch" {
  function_name    = "${var.name_prefix}-LogsToElasticsearch"
  handler          = "Logforwarding.handler"
  role             = aws_iam_role.logs_to_elasticsearch_role.arn
  runtime          = "nodejs14.x"
  description      = "Sends logs from CloudWatch to AWS ElasticSearch Service"
  timeout          = "60"
  memory_size      = "128"
  filename         = data.archive_file.logforwardingelastic.output_path
  source_code_hash = data.archive_file.logforwardingelastic.output_base64sha256

  environment {
    variables = {
      password = data.aws_ssm_parameter.password.value
      hostname = var.hostname
      port     = var.port
      username = var.username
      index    = var.index
    }
  }
  depends_on = [aws_cloudwatch_log_group.eclog]
}

resource "aws_cloudwatch_log_group" "eclog" {
  name              = "/aws/lambda/${var.name_prefix}-LogsToElasticsearch"
  retention_in_days = 3
}

resource "aws_iam_role" "logs_to_elasticsearch_role" {
  name               = "${var.name_prefix}-logstoelasticsearch-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.logs_to_elasticsearch_role_policy.json

  tags = var.tags
}

resource "aws_iam_role_policy" "logs_to_elasticsearch_policy" {
  role   = aws_iam_role.logs_to_elasticsearch_role.id
  policy = data.aws_iam_policy_document.logs_to_elasticsearch_policy.json
}

data "aws_iam_policy_document" "logs_to_elasticsearch_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "logs_to_elasticsearch_policy" {
  statement {
    effect = "Allow"
    actions = [
      "es:*",
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_lambda_alias" "log_to_elasticsearch_alias" {
  name             = var.name_prefix
  description      = "AWS environment"
  function_name    = aws_lambda_function.logs_to_elasticsearch.arn
  function_version = "$LATEST"

  lifecycle {
    ignore_changes = [function_version]
  }
}

resource "aws_lambda_permission" "allow_invocation_from_logs" {
  statement_id  = "AllowExecutionFromLogs"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.logs_to_elasticsearch.arn
  qualifier     = aws_lambda_alias.log_to_elasticsearch_alias.name

  principal = "logs.${data.aws_region.current.name}.amazonaws.com"
}

