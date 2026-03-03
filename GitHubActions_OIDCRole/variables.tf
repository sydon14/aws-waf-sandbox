variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "IAM role name that GitHub Actions will assume"
  type        = string
  default     = "GitHubActions_OIDCRole"
}

variable "github_org" {
  description = "GitHub org or username"
  type        = string
  default     = "sydon14"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "aws-waf-sandbox"
}

# Optional (leave for later; not needed if you're not using KMS encryption on the state bucket)
# variable "kms_key_arn" {
#   description = "KMS key ARN used for backend S3 state encryption (optional)"
#   type        = string
#   default     = ""
# }