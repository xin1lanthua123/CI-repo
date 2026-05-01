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