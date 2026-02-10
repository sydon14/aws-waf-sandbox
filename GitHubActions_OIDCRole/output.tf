output "github_actions_role_arn" {
    description = "The ARN of GitHub Actions OIDC Role"
    value = aws_iam_role.github_actions_role.arn
}

# output "oidc_provider_arn" {
#     description = "The ARN of OIDC Provider"
#     value = aws_iam_openid_connect_provider.github.arn
# }