include "root" {
    path = find_in_parent_folders("root.hcl")
}
include "env" {
    path = find_in_parent_folders("env.hcl")
    expose = true
    merge_strategy = "no_merge"
    }
terraform {
    source = "../../../../modules/irsa"
}
inputs = {
  domain_name             = include.env.locals.irsa.enable_eks_addons.domain_name
  vpc_id                  = dependency.vpc.outputs.vpc_id
  project_name            = include.env.locals.tags.Project
  region                  = include.env.locals.irsa.enable_eks_addons.region
  tags                    = include.env.locals.tags
  env                     = include.env.locals.tags.env
  enable_alb_controller   = include.env.locals.irsa.enable_eks_addons.enable_alb_controller
  enable_dns_external     = include.env.locals.irsa.enable_eks_addons.enable_dns_external
  enable_ebs_csi_driver   = include.env.locals.irsa.enable_eks_addons.enable_ebs_csi_driver
  enable_eso              = include.env.locals.irsa.enable_eks_addons.enable_eso
  enable_karpenter        = include.env.locals.irsa.enable_eks_addons.enable_karpenter

  eks_cluster_arn         = dependency.eks_core.outputs.eks_cluster_arn
  oidc_provider_arn       = dependency.eks_core.outputs.oidc_provider_arn
  oidc_provider_url       = dependency.eks_core.outputs.oidc_provider_url
  cluster_name            = dependency.eks_core.outputs.cluster_name
  cluster_ca              = dependency.eks_core.outputs.cluster_ca
  cluster_endpoint        = dependency.eks_core.outputs.cluster_endpoint

  karpenter_sa            = include.env.locals.irsa.service_accounts.karpenter_sa
  external_secrets_sa     = include.env.locals.irsa.service_accounts.external_secrets_sa
  external_dns_sa         = include.env.locals.irsa.service_accounts.external_dns_sa
  ebs_csi_driver_sa       = include.env.locals.irsa.service_accounts.ebs_csi_driver_sa
  ebs_csi_version         = include.env.locals.irsa.service_accounts.ebs_csi_version
  alb_service_sa          = include.env.locals.irsa.service_accounts.alb_service_sa
  helm_argocd_version     = include.env.locals.irsa.service_accounts.helm_argocd_version
  server_insecure         = include.env.locals.irsa.service_accounts.server_insecure
}

dependency "eks_core" {
    config_path = "../eks_core"
    
    mock_outputs = {
    cluster_endpoint = "https://mock"
    cluster_ca       = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCg=="
    eks_cluster_arn = "arn:aws:eks:us-east-1:123456789012:cluster/mock-cluster"
    oidc_provider_arn = "arn:aws:iam::111111111111:oidc-provider/oidc.eks.ap-southeast-1.amazonaws.com/id/MOCK"
    oidc_provider_url = "oidc.eks.ap-southeast-1.amazonaws.com/id/MOCK"
    cluster_name      = "eks-cluster"
  }

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]
    
}
dependency "vpc" {
    config_path = "../vpc"
   
    mock_outputs = {
    vpc_id = "vpc-000000000000"
  }

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init"]
}


