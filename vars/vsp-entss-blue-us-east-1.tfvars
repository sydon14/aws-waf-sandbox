region         = "us-east-1"
Environment    = "dev"
DeployColor    = "blue"
CreatedBy      = "tanmayee.sathe@unisys.com"
AccountNumber  = "884316347283"
AccountName    = "vsp"
Description    = "Shared Service: WAF deployment"
EnvironmentTag = "entss"
ServiceName="common-stack/waf"
STATE_STORE = "fedramp-mod-remote-tfstate-bucket-prod"
ROLE_ARN = "arn:aws:iam::884316347283:role/fedramp-mod-tfstate-bucket-access-role"
waf_acl_name = "VSPAgencyIngressWAF"
waf_scope = "REGIONAL"  
web_acl_description = "WAF for Agency Ingress ALBg"
elb_arn = "arn:aws:elasticloadbalancing:us-east-1:884316347283:loadbalancer/app/AgencyIngressALB/96d097e73c27f654"
waf_association = "false"
# WAF variables
allow_rule_priority = 2
waf_geo_match_country_codes = ["US"]
create_resource_policy = false
log_retention_days = 30
ip_addresses = [
    "20.253.118.128/28",
    "64.207.216.0/22",
    "20.12.134.144/28",
    "20.7.89.192/28",
    "20.12.135.144/28",
    "20.7.90.64/28",
    "20.171.224.80/28",
    "20.125.64.104/31",
    "20.253.118.176/28",
    "20.236.201.102/31",
    "20.7.90.48/28",
    "20.12.135.160/28",
    "20.253.118.160/28",
    "20.171.224.16/28",
    "20.241.243.190/31",
    "20.40.31.128/28",
    "162.248.184.0/22",
    "52.177.241.22/31",
    "209.112.104.0/22"
  ]
  vpc_tags = {
    vita-customer-id = "0156"
    cov-request      = "PRJ0014048"
    project-name     = "VSP AWS Set up"
  }
  logs_tags = {
    "Project"          = "VSP AWS Set up"
  }