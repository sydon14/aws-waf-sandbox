variable "region" {
  description = "AWS Region"
  type = string
  default = "us-east-1"
}

variable "role_name" {
  description = "Name of Github Actions"
  type = string
  default = "GitHubActionsOIDCRole"
}

variable "github_org" {
  description = "Name of Github Organization of username"
  type = string
  default = "COV-VITA"
}

variable "github_repo" {
  description = "Name of Github Repository"
  type = string
  default = "AWS-Unisys-ATOS-WAF"
}

variable "AWSRegion" {
  description = "AWS Region"
  type = string
}

variable "ROLE_ARN" {
  description = "ROLE_ARN for terraform backend "
  type = string
}

variable "oidc_arn" {
    description = "OIDC ARN"
  type = string
}

variable "kms_key_arn" {
  description = "KMS key ARN used for backend S3 state encryption"
  type        = string
}