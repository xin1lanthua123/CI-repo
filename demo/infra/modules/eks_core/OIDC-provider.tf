# ----------------------------
# OIDC Provider for IRSA
# ----------------------------
data "tls_certificate" "oidc" {
  count = var.enable_irsa ? 1 : 0
  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "oidc" {
  count = var.enable_irsa ? 1 : 0
  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    try(data.tls_certificate.oidc[0].certificates[0].sha1_fingerprint,null)
  ]
}