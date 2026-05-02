output "alb_role_arn" {
  value = aws_iam_role.alb_irsa_role[0].arn
}
output "role_arn" {
  value = aws_iam_role.ebs_csi[0].arn
}
output "externaldns_role_arn" {
  value = aws_iam_role.externaldns_irsa[0].arn
}

output "karpenter_role_arn" {
  value = aws_iam_role.karpenter_irsa[0].arn
}

output "eso_role_arn" {
  value = aws_iam_role.eso_irsa[0].arn
}

output "ebs_csi_version" {
  value = aws_eks_addon.ebs_csi[0].addon_version
} 
output "ebs_csi_role_arn" {
  value       = var.enable_ebs_csi_driver ? aws_iam_role.ebs_csi[0].arn : null
  description = "IAM role ARN for EBS CSI Driver"
}
output "argocd_namespace" {
  value = kubernetes_namespace_v1.argocd.metadata[0].name
}

output "argocd_release_name" {
  value = helm_release.argocd.name
}

