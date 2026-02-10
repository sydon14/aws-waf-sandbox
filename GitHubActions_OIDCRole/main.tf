provider "aws" {
  region = var.region
}

# ##OIDC Provider for GitHub

# resource "aws_iam_openid_connect_provider" "github"{
#     url = "https://token.actions.githubusercontent.com"
#     client_id_list = ["https://github.com/COV-VITA"]
#     thumbprint_list = [
#         "6938fd4d98bab03faadb97b34396831e3780aea1"
#     ]
# }

## IAM ROLE for GitHub OIDC

resource "aws_iam_role" "github_actions_role" {
    name = var.role_name
    assume_role_policy = templatefile(
        "${path.module}/policies/github_actions_trust.json",
        {
            github_org = var.github_org
            github_repo = var.github_repo
            oidc_arn = var.oidc_arn
    
        }
    )
    
}

###IAM Policy

resource "aws_iam_policy" "github_actions_policy" {
    name = "GitHubActionsLimitedAccess"
    description = "Allow only CloudWatch Logs write , S3 list/read/write/delete, wafv2 full Access "
    policy =  templatefile(
      "${path.module}/policies/github_actions_policy.json",
      {
        kms_key_arn = var.kms_key_arn
      }
    )
}

## Attach policy to IAM Role

resource "aws_iam_role_policy_attachment" "github_actions_policy_attachment" {
  role = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_actions_policy.arn
}