output "log_to_elasticsearch_alias" {
  description = "Elastic Cloud arn"
  value       = aws_lambda_alias.log_to_elasticsearch_alias.arn
}
