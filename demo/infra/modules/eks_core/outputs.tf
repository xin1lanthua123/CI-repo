output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}
output "cluster_name" {
  value = aws_eks_cluster.eks.name
}
output "eks_cluster_arn" {
  value = aws_eks_cluster.eks.arn
}
output "cluster_ca" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "oidc_provider_arn" {
  value = try(aws_iam_openid_connect_provider.oidc[0].arn,null)
}

output "oidc_provider_url" {
  value = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}
