variable "name_prefix" {
  description = "A prefix used for naming resources."
}

variable ssm_password_name {
  description = "Kibana user password parameter name (value stored as SecureString)"
}

variable ssm_password_arn {
  description = "Kibana user password parameter arn"
}

variable hostname {
  description = "The elastic cloud ingestion base url without https"
}

variable port {
  description = "The elastic cloud ingestion host port"
}

variable username {
  description = "The kibana user username"
}

variable index {
  description = "The name of the index to which they"
  default     = "prm"
}

variable enable_alarm {
    description = "Enable alarm for failed invocations of the lambda function"
    default     = false

}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}


/*
 * == Alarm Configuration
 */
variable "alarm_sns_topic_arns" {
  description = "Where to send Alarms and OKs"
  type        = list(string)
}

variable "error_threshold" {
  description = "Amount of times the lambda can fail before an alarm is triggered"
  type        = number
  default     = 10
}

variable "times_failed" {
  description = "Amount of elapsed evaluation periods before an alarm is triggered"
  type        = number
  default     = 1
}

variable "treat_missing_data" {
  description = "How this alarm is to handle missing data points"
  type        = string
  default     = "missing"
}


variable "period" {
  description = "Period in seconds to check for the applied statistic"
  type        = number
  default     = 300
}

