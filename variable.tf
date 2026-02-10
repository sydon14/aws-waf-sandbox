# WAF variables

variable "region" {
  description = "The AWS region to deploy resources into."
  type        = string
}

variable "waf_acl_name" {
  description = "WAF ACL name."
  type        = string
}
variable "create_resource_policy" {
  description = "Enable resource policy."
  type        = bool
  default = false
}

variable "waf_scope" {
  description = "Scope of the WAF (REGIONAL or CLOUDFRONT)"
  type        = string
  default     = "REGIONAL"
}

variable "log_retention_days" {
  description = "Retention period for CloudWatch logs"
  type        = number
  default     = 30
}

variable "redacted_headers" {
  description = "List of headers to be redacted"
  type        = list(string)
  default     = ["user-agent"]
}


variable "elb_arn" {
  description = ""
  type        = string
}


variable "vpc_tags" {
  description = "Tags for VPC resources"
  type        = map(string)
}

variable "logs_tags" {
  description = "Tags for Log Group  resources"
  type        = map(string)
}


variable "web_acl_description" {
  description = "Description for the WAF Web ACL"
  type        = string
  default     = ""
}

variable "AccountName" {
  description = "The name of the agency account"
  type        = string
}



variable "waf_association" {
  description = "Set to true if we need waf association (e.g. true, false)"
  type        = string
  default     = false
}