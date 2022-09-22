variable "name_prefix" {
  description = "A prefix used for naming resources."
}

variable ssm_name_password {
  description = "Kibana user password parameter name"
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

