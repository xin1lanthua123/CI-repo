# EBS CSI DRIVER IRSA ROLE
resource "aws_iam_role" "ebs_csi" {
  count = var.enable_ebs_csi_driver ? 1 : 0
  name = "${var.cluster_name}-ebs-csi-driver"

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
  cluster_name             = var.cluster_name            #"prod-my-app-eks"
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = aws_iam_role.ebs_csi[0].arn
  # resolve_conflicts_on_create = "OVERWRITE"
  # resolve_conflicts_on_update = "OVERWRITE"
  resolve_conflicts = "OVERWRITE"
  addon_version = var.ebs_csi_version

}
