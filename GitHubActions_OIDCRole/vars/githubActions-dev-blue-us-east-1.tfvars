region      = "us-east-1"
AWSRegion   = "us-east-1"
Environment = "dev"
DeployColor = "blue"
CreatedBy   = "sydon_md@yahoo.com"

ServiceName = "common-stack/githubActions/roles"

STATE_STORE = "vita-waf-tfstate-sydon"

# Not needed in your sandbox unless you're assuming a role for backend access
ROLE_ARN    = ""

# If Terraform will create the OIDC provider, this can stay blank for now.
# If you decide NOT to create it, then set it to:
# arn:aws:iam::782557964167:oidc-provider/token.actions.githubusercontent.com
oidc_arn    = ""

AccountName = "githubActions"

kms_key_arn = ""