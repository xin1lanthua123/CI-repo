data "aws_caller_identity" "current" {}
resource "aws_iam_role" "eso_irsa" {
  count = var.enable_eso ? 1 : 0
  name = "${var.cluster_name}-eso-irsa"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = var.oidc_provider_arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.oidc_host}:sub" = "system:serviceaccount:external-secrets:${var.external_secrets_sa }",
            "${local.oidc_host}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "eso_policy" {
  count = var.enable_eso ? 1 : 0
  name        = "${var.cluster_name}-eso-policy"
  description = "Allow External Secrets Operator to read AWS Secrets Manager secrets"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # ESO often needs to list secrets
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:ListSecrets"
        ],
        Resource = "*"
      },

      # Read only allowed secrets
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        # Resource = var.secrets_manager_arns
        Resource = "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:${var.project_name}/${var.env}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eso_attach" {
  role       = aws_iam_role.eso_irsa[0].name
  policy_arn = aws_iam_policy.eso_policy[0].arn
}

