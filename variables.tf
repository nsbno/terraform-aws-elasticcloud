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

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}

