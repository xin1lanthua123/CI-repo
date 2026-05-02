# EBS CSI DRIVER IRSA ROLE
resource "aws_iam_role" "ebs_csi" {
  count = var.enable_ebs_csi_driver ? 1 : 0
  name = "${var.cluster_name}-ebs-csi-driver-${var.env}"

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
            "${local.oidc_host}:sub" = "system:serviceaccount:kube-system:${var.ebs_csi_driver_sa}"
            "${local.oidc_host}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ebs_csi_attach" {
  count = var.enable_ebs_csi_driver ? 1 : 0
  role       = aws_iam_role.ebs_csi[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_eks_addon" "ebs_csi" {
  count = var.enable_ebs_csi_driver ? 1 : 0
  cluster_name             = var.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = aws_iam_role.ebs_csi[0].arn
}
# resource "helm_release" "ebs_csi" {
#   count = var.enable_ebs_csi_driver ? 1 : 0
#   name       = "aws-ebs-csi-driver"
#   namespace  = "kube-system"
#   repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
#   chart      = "aws-ebs-csi-driver"
#   version =  "2.59.0"
#   atomic          = true
#   cleanup_on_fail = true
#   wait            = true
#   timeout         = 300

#   set {
#     name  = "controller.serviceAccount.create"
#     value = "false"
#   }

#   set {
#     name  = "controller.serviceAccount.name"
#     value = var.ebs_csi_driver_account
#   }

#   set {
#     name  = "node.serviceAccount.create"
#     value = "false"
#   }

#   set {
#     name  = "node.serviceAccount.name"
#     value = var.ebs_csi_driver_account
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.ebs_csi_attach,
#     kubernetes_service_account_v1.ebs_csi[0]
#   ]
# }
