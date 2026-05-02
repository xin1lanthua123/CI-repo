variable "project_name" {
  type = string
  default = "my-app"
}

variable "region" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "eks_cluster_arn" {
  type = string
}
variable "cluster_name" {
  type = string
  default = "eks"
}
variable "cluster_endpoint" {
  type = string
}
variable "cluster_ca" {
  type = string 
}
variable "oidc_provider_arn" {
  type = string
}

variable "oidc_provider_url" {
  type = string
}

variable "external_secrets_sa" {
  type = string
}
variable "ebs_csi_driver_sa" {
  type = string
  default = "ebs-csi-controller-sa"
}

variable "ebs_csi_version" {
  type = string
  default = null
}
variable "external_dns_sa" {
  type = string
  default = "external-dns"
}
variable "karpenter_sa" {
  type = string
}

variable "alb_service_sa" {
  type    = string
  default = "aws-load-balancer-controller"
}
variable "env" {
  type = string 
}
variable "tags" {
  type = map(string)
  default = {
  Name        = "eks-cluster"
  Environment = "prod"
  ManagedBy   = "Terraform"
}
}

variable "route53_zone_arns" {
  type        = list(string)
  description = "List of Route53 Hosted Zone ARNs ExternalDNS can manage"
  default     = []
}
variable "domain_name" {
  type = string
}
variable "enable_alb_controller" {
  type = bool
  default = true
}
variable "enable_dns_external" {
  type = bool
  default = true
}
variable "enable_ebs_csi_driver" {
  type = bool
  default = true
}
variable "enable_eso" {
  type = bool
  default = true
}
variable "enable_karpenter" {
  type = bool
  default = true
}
variable "helm_argocd_version" {
  type = string
  default = "null"
}
variable "server_insecure" {
  type = bool
  description = "value"
  default = true
}