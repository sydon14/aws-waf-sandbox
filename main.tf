locals {
  vpc_tags = var.vpc_tags
}

locals {

  rule_files = fileset("rules/${var.AccountName}", "*.tpl")

  needs_ip_set = length([
    for f in local.rule_files :
    f if strcontains(file("rules/${var.AccountName}/${f}"), "$${ip_set_arn}")
  ]) > 0

  # Load IP set config from JSON if needed
  ip_set_config = local.needs_ip_set ? jsondecode(file("rules/${var.AccountName}/config/ip_set_config.json")) : null

  shared_rule_vars = {
    ip_set_arn = local.needs_ip_set ? aws_wafv2_ip_set.ip_set[0].arn : null
  }

  rendered_rules = [
    for file in local.rule_files : jsondecode(
      templatefile("rules/${var.AccountName}/${file}", local.shared_rule_vars)
    )
  ]

  rules_list = [
    for r in local.rendered_rules : r
    if !(try(contains(jsonencode(r), "ip_set_arn"), false) && local.shared_rule_vars.ip_set_arn == null)
  ]

  is_agency_ingress = var.waf_acl_name == "AgencyIngressWAF"
}


provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_wafv2_ip_set" "ip_set" {
  count       = local.needs_ip_set ? 1 : 0
  name        = local.ip_set_config.name
  scope       = var.waf_scope
  description = local.ip_set_config.description
  ip_address_version = local.ip_set_config.ip_address_version
  addresses = local.ip_set_config.addresses
}

resource "aws_wafv2_web_acl" "web_acl" {
  name        = var.waf_acl_name
  scope       = var.waf_scope
  description = var.web_acl_description
  dynamic "challenge_config" {
    for_each = local.is_agency_ingress ? [1] : []
    content {
      immunity_time_property {
        immunity_time = 3600
      }
    }
  }
  token_domains = local.is_agency_ingress ? [
      "appsd.dbhds.virginia.gov",
      "dbhds.virginia.gov",
   ] : null
  default_action {
    allow {}
  }


  rule_json = jsonencode(local.rules_list)

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "entts-metric"
    sampled_requests_enabled   = true
  }

  tags = local.vpc_tags

}

# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "waf_log_group" {
  name = "aws-waf-logs-${var.waf_acl_name}"# the prefix aws-waf-logs is required, do not modify
  retention_in_days = var.log_retention_days                 # Optional: Set log retention period
  tags = var.logs_tags
}

data "aws_iam_policy_document" "waf_log_group_policy" {
  count = var.create_resource_policy ? 1 : 0
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:aws-waf-logs-*"
    ]
    condition {
      test     = "ArnLike"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
      variable = "aws:SourceArn"
    }
    condition {
      test     = "StringEquals"
      values   = [tostring(data.aws_caller_identity.current.account_id)]
      variable = "aws:SourceAccount"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "example" {
  count = var.create_resource_policy ? 1 : 0
  policy_document = data.aws_iam_policy_document.waf_log_group_policy[0].json
  policy_name     = "webacl_log_group_policy"
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {
  log_destination_configs = [
    aws_cloudwatch_log_group.waf_log_group.arn
  ]
  resource_arn = aws_wafv2_web_acl.web_acl.arn

 dynamic "redacted_fields" {
    for_each = var.redacted_headers
    content {
      single_header {
        name = redacted_fields.value
      }
    }
  }
}

resource "aws_wafv2_web_acl_association" "waf_association" {
  count = var.waf_association ? 1 : 0
  resource_arn = var.elb_arn
  web_acl_arn  = aws_wafv2_web_acl.web_acl.arn
}

output "rendered_rules_json" {
  value = jsonencode(local.rules_list)
}