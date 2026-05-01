# resource "random_id" "suffix" {
#   byte_length = 4
# }

# module "vpc" {
#   source       = "./modules/vpc"
#   project_name = var.project_name
 
# }

# module "eks_core" {
#     source = "./modules/eks_core"
#     project_name = var.project_name
#     node_groups = var.node_groups
#     private_subnet_ids = module.vpc.private_subnet
#     cluster_version = var.cluster_version
# }

# module "eks_irsa" {
#     source = "./modules/eks_irsa"
#     project_name = var.project_name
#     oidc_provider_arn = module.eks_core.oidc_provider_arn
#     oidc_provider_url = module.eks_core.oidc_provider_url
#     namespace              = var.namespace
#     backend_service_account = var.backend_service_account
#     alb_service_account = var.alb_service_account
   
# }
