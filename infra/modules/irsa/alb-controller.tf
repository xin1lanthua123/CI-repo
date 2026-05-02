locals {
  oidc_host = replace(var.oidc_provider_url, "https://", "")
}

resource "aws_iam_role" "alb_irsa_role" {
  count = var.enable_alb_controller? 1 : 0
  name = "${var.env}-${var.cluster_name}-alb-irsa-role-${var.env}"

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
          "${local.oidc_host}:sub" = "system:serviceaccount:kube-system:${var.alb_service_account}"
          "${local.oidc_host}:aud" = "sts.amazonaws.com"
         
        }
      }
    }]
  })
  tags = var.tags
}

resource "aws_iam_policy" "alb_controller_policy" {
  count = var.enable_alb_controller ? 1 : 0
  name = "${var.env}-${var.cluster_name}-alb-controller-policy"

  policy = file("${path.module}/iam_policy_alb_controller.json")
}

resource "aws_iam_role_policy_attachment" "alb_attach" {
  role       = aws_iam_role.alb_irsa_role[0].name
  policy_arn = aws_iam_policy.alb_controller_policy[0].arn
}

resource "kubernetes_service_account_v1" "alb" {
  count = var.enable_alb_controller ? 1 : 0
  metadata {
    name      = var.alb_service_sa
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_irsa_role[0].arn
    }
  }
}
resource "helm_release" "aws_lb_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version = "1.7.2"
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 300

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = var.alb_service_sa
  }

  set {
    name  = "region"
    value = var.region
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  depends_on = [
    aws_iam_role_policy_attachment.alb_attach,
    kubernetes_service_account_v1.alb[0]
  ]
}
