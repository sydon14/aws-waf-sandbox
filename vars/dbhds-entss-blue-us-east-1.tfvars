region         = "us-east-1"
Environment    = "dev"
DeployColor    = "blue"
CreatedBy      = "sydon.agbor@atos.net"
AccountNumber  = "782557964167"
AccountName    = "DBHDS"
Description    = "Sandbox: WAF deployment"
EnvironmentTag = "sandbox"
ServiceName="common-stack/waf"
STATE_STORE = "vita-waf-tfstate-sydon"
ROLE_ARN = "arn:aws:iam::884316347283:role/fedramp-mod-tfstate-bucket-access-role"
waf_acl_name = "DBHDSAgencyIngressWAF-sandbox"
waf_scope = "REGIONAL"
web_acl_description = "Sandbox WAF for DBHDS ALB"
elb_arn = "arn:aws:elasticloadbalancing:us-east-1:782557964167:loadbalancer/app/dbhds-waf-test-alb/9b7c5edc2529189e"
waf_association = false
# WAF variables
allow_rule_priority = 2
waf_geo_match_country_codes = ["US"]
create_resource_policy = false
log_retention_days = 30
# ip_addresses = [
#     "20.253.118.128/28",
#     "209.112.104.0/22"
#   ]
vpc_tags = {
  project-name = "aws-waf-sandbox"
  owner        = "Sydon"
  environment  = "dev"
  agency       = "dbhds"
}
logs_tags = {
  project = "aws-waf-sandbox"
  agency  = "dbhds"
}