resource "aws_iam_role" "github_actions_bootstrap" {
  name = "${var.project_name}-github-bootstrap-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:*"
        }
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
      }
      
    }]
  })
}

resource "aws_iam_role_policy_attachment" "bootstrap" {
  role       = aws_iam_role.github_actions_bootstrap.name
  policy_arn = aws_iam_policy.github_actions_bootstrap_policy.arn
}


