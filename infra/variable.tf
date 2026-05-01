variable "project_name" {
    type = string
}

variable "frontend_bucket_prefix" {
  type        = string
  description = "Prefix name for frontend hosting bucket"
  default     = "cloud-incident-frontend"
}

variable "bucket_name" {
  type = string
}
variable "backend_alb_dns" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "oidc_provider_url" {
  type = string
}

variable "namespace" {
  type    = string
  default = "incident-system"
}

variable "backend_service_account" {
  type    = string
  default = "incident-backend-sa"
}

variable "alb_service_account" {
  type    = string
  default = "aws-load-balancer-controller"
}

variable "cluster_version" {
  type    = string
  default = "1.30"
}
variable "node_groups" {
  description = "groups of node"
  type = map(object({
    node_instance_type = string
    desired_size = number
    min_size = number
    max_size = number
  }))
  default = {
    "group1" = {
      node_instance_type = "t3.micro"
      desired_size = 2
      min_size = 1
      max_size = 3
    }
    "group2" = {
      node_instance_type = "t3.medium"
      desired_size = 2
      min_size = 1
      max_size = 3
    }
    
  }

}
variable "env" {
  type = string
}
variable "enable_irsa" {
  description = "modifying whether do you like to change it or not"
  type = bool
  default = true
}