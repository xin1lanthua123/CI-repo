include "root" {
    path = find_in_parent_folders()
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
  domain_name             =  include.env.locals.irsa.domain_name
  vpc_id                  = dependency.vpc.outputs.vpc_id
  project_name            = include.env.locals.tags.Project
  region                  = include.env.locals.irsa.region
  tags                    = include.env.locals.tags
  env                     = include.env.locals.tags.env
  enable_alb_controller   = include.env.locals.irsa.enable_alb_controller
  enable_dns_external   = include.env.locals.irsa.enable_dns_external
  enable_ebs_csi_driver = include.env.locals.irsa.enable_ebs_csi_driver
  enable_eso            = include.env.locals.irsa.enable_eso
  enable_karpenter      = include.env.locals.irsa.enable_karpenter
  oidc_provider_arn       = dependency.eks_core.outputs.oidc_provider_arn
  oidc_provider_url       = dependency.eks_core.outputs.oidc_provider_url
  cluster_name            = dependency.eks_core.outputs.cluster_name
  karpenter_sa            = "karpenter"
  external_secrets_sa     = "external-secrets"
  external_dns_sa         = "external-dns"
  ebs_csi_driver_sa       = "ebs-csi-controller-sa"
  alb_service_sa          = include.env.locals.service_accounts.alb_service_account
}
dependency "eks_core" {
    config_path = "../eks_core"
    mock_outputs = {
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


