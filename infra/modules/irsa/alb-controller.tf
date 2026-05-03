locals {
  oidc_host = replace(var.oidc_provider_url, "https://", "")
}

resource "aws_iam_role" "alb_irsa_role" {
  count = var.enable_alb_controller? 1 : 0
  name = "${var.cluster_name}-alb-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = var.oidc_provider_arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${local.oidc_host}:sub" = "system:serviceaccount:kube-system:${var.alb_service_sa}"
          "${local.oidc_host}:aud" = "sts.amazonaws.com"
         
        }
      }
    }]
  })
  tags = var.tags
}

resource "aws_iam_policy" "alb_controller_policy" {
  count = var.enable_alb_controller ? 1 : 0
  name = "${var.cluster_name}-alb-controller-policy"

  policy = file("${path.module}/iam_policy_alb_controller.json")
}

resource "aws_iam_role_policy_attachment" "alb_attach" {
  role       = aws_iam_role.alb_irsa_role[0].name
  policy_arn = aws_iam_policy.alb_controller_policy[0].arn
}
