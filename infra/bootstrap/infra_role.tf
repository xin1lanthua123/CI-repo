
resource "aws_iam_role" "github_actions_infra" {
  name = "${var.project_name}-github-infra-and-backend-state-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          "token.actions.githubusercontent.com:sub" = "repo:org/repo:environment:${var.env}"
        }
      }
      
    }]
  })
}
resource "aws_iam_role_policy_attachment" "infra" {
  role       = aws_iam_role.github_actions_infra.name
  policy_arn = aws_iam_policy.github_actions_infra_policy.arn
}

resource "aws_iam_role_policy_attachment" "backend" {
  role       = aws_iam_role.github_actions_infra.name
  policy_arn = aws_iam_policy.github_actions_backend_policy.arn
}