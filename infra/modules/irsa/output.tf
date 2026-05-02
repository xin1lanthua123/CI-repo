output "alb_role_arn" {
  value = aws_iam_role.alb_irsa_role[0].arn
}
output "role_arn" {
  value = aws_iam_role.ebs_csi[0].arn
}
output "externaldns_role_arn" {
  value = aws_iam_role.externaldns_irsa[0].arn
}
output "ebs_csi_role_arn" {
  value = aws_iam_role.ebs_csi[0].arn
}
output "karpenter_role_arn" {
  value = aws_iam_role.karpenter_irsa[0].arn
}

output "eso_role_arn" {
  value = aws_iam_role.eso_irsa[0].arn
}
output "alb_chart_status" {
  value = helm_release.aws_lb_controller.status
}
output "karpenter_status" {
  value = helm_release.karpenter.status
}
output "external_secret_status" {
  value = helm_release.external_secrets.status
}
output "ebs_csi_status" {
  value = helm_release.ebs_csi.status
}
output "dns_external_status" {
  value = helm_release.externaldns.status
}
output "ebs_csi_version" {
  value = aws_eks_addon.ebs_csi.addon_version
}

