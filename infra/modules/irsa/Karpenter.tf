resource "aws_iam_role" "karpenter_irsa" {
  count = var.enable_karpenter ? 1 : 0
  name = "${var.cluster_name}-karpenter-irsa-${var.env}"

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
            "${local.oidc_host}:sub" = "system:serviceaccount:karpenter:karpenter",
            "${local.oidc_host}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "karpenter_policy" {
  count = var.enable_karpenter ? 1 : 0
  name        = "${var.cluster_name}-karpenter-policy-${var.env}"
  description = "Allow Karpenter to provision EC2 instances"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Allow Karpenter to create EC2 capacity
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateLaunchTemplate",
          "ec2:DeleteLaunchTemplate",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeLaunchTemplateVersions",

          "ec2:CreateFleet",
          "ec2:RunInstances",
          "ec2:TerminateInstances",

          "ec2:CreateTags",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeImages",
          "ec2:DescribeSpotPriceHistory",
          "ec2:DescribeVpcs"
        ],
        Resource = "*"
      },

      # Required to discover cluster endpoint and CA
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster"
        ],
        Resource = "*"
      },

      # Pricing API is used for instance selection
      {
        Effect = "Allow",
        Action = [
          "pricing:GetProducts"
        ],
        Resource = "*"
      },

      # Allow passing instance profile role to EC2 nodes created by Karpenter
      {
        Effect = "Allow",
        Action = [
          "iam:PassRole"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "karpenter_attach" {
  role       = aws_iam_role.karpenter_irsa[0].name
  policy_arn = aws_iam_policy.karpenter_policy[0].arn
}

resource "kubernetes_namespace_v1" "karpenter" {
  count = var.enable_karpenter ? 1 : 0

  metadata {
    name = "karpenter"
  }
}
resource "kubernetes_service_account_v1" "karpenter" {
  count = var.enable_karpenter ? 1 : 0

  metadata {
    name      = var.karpenter_sa   
    namespace = "karpenter"

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.karpenter_irsa[0].arn
    }
  }
}

resource "helm_release" "karpenter" {
  count = var.enable_karpenter ? 1 : 0

  name       = "karpenter"
  namespace  = "karpenter"
  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter"
  version    = "1.12.0"
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 300
  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = var.karpenter_sa            
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.karpenter_irsa[0].arn
  }

  set {
    name  = "settings.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "settings.clusterEndpoint"
    value = data.aws_eks_cluster.eks.endpoint
  }

  depends_on = [
    aws_iam_role_policy_attachment.karpenter_attach,
    kubernetes_service_account_v1.karpenter[0],
    kubernetes_namespace_v1.karpenter[0]
  ]
}