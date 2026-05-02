data "aws_caller_identity" "current" {}
resource "aws_iam_role" "eso_irsa" {
  count = var.enable_eso ? 1 : 0
  name = "${var.cluster_name}-eso-irsa-${var.env}"

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
            "${local.oidc_host}:sub" = "system:serviceaccount:external-secrets:external-secrets",
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
  name        = "${var.cluster_name}-eso-policy-${var.env}"
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

resource "kubernetes_service_account_v1" "eso" {
  count = var.enable_eso ? 1 : 0

  metadata {
    name      = var.external_secrets_sa
    namespace = "external-secrets"

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.eso_irsa[0].arn
    }
  }
}

resource "kubernetes_namespace_v1" "eso" {
  count = var.enable_eso ? 1 : 0
  metadata {
    name = "external-secrets"
  }
}
resource "helm_release" "external_secrets" {
  count = var.enable_eso ? 1 : 0

  name       = "external-secrets"
  namespace  = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "2.4.1"
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 60

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = var.external_secrets_sa
  }

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eso_attach,
    kubernetes_service_account_v1.eso[0],
    kubernetes_namespace_v1.eso[0]
  ]
}