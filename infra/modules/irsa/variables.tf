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
variable "cluster_name" {
  type = string
  default = "eks"
}
variable "oidc_provider_arn" {
  type = string
}

variable "oidc_provider_url" {
  type = string
}

variable "ebs_csi_driver_account" {
  type = string
  default = "ebs-csi-controller-sa"
}

variable "alb_service_account" {
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
    