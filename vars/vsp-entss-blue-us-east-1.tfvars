region         = "us-east-1"
Environment    = "dev"
DeployColor    = "blue"
CreatedBy      = "sydon.agbor@atos.net"
AccountNumber  = "782557964167"
AccountName    = "vsp"
Description    = "Sandbox: WAF deployment"
EnvironmentTag = "sandbox"
ServiceName="common-stack/waf"
STATE_STORE = "vita-waf-tfstate-sydon"
ROLE_ARN = ""
waf_acl_name = "VSPAgencyIngressWAF-sandbox"
waf_scope = "REGIONAL"
web_acl_description = "Sandbox WAF for VSP ALB"
elb_arn = "arn:aws:elasticloadbalancing:us-east-1:782557964167:loadbalancer/app/vsp-waf-test-alb/88965192cea12d8b"
waf_association = true
# WAF variables
allow_rule_priority = 2
waf_geo_match_country_codes = ["US"]
create_resource_policy = false
log_retention_days = 30
# ip_addresses = ["104.129.206.113/32"]
#     "20.253.118.128/28",
#     "209.112.104.0/22"
#   ]
vpc_tags = {
  project-name = "aws-waf-sandbox"
  owner        = "Sydon"
  environment  = "dev"
  agency       = "vsp"
}
logs_tags = {
  project = "aws-waf-sandbox"
  agency  = "vsp"
}