
locals {
  tags = {
    env          = "prod"
    Project      = "my-app"
    ManagedBy    = "terraform"
  }
  aws_secret_manager = {
    secret_for_rds = {
      db_name = "prod-postgres-db"
      username = "my-app-db"
      password = "set up in secret manager module"
    }
  }
  irsa = { 
    enable_eks_addons = {
      domain_name           = "quanldl.uk"
      region                = "us-east-1"
      enable_alb_controller = true
      enable_dns_external   = true
      enable_ebs_csi_driver = true
      enable_eso            = true
      enable_karpenter      = true
  }
    service_accounts = {
      alb_service_sa          = "aws-load-balancer-controller"
      karpenter_sa            = "karpenter"
      external_secrets_sa     = "external-secrets"
      ebs_csi_driver_sa       = "ebs-csi-controller-sa"
      ebs_csi_version         = "2.59.0"
      helm_argocd_version     = "7.8.2"
      server_insecure         = true
  }
  }
  S3_logs = {
    enable_kms = true
  }
  vpc = {
     single_nat_gateway = true
  }
  rds = {
    engine_version = "15"
    multi_az       = false
    instance_class = "db.t3.medium"
    db_name        = "prodpostgresdb"
    db_username    = "myappdb"
  }
  eks = {
      cluster_version = "1.30"
      enable_irsa     = true
      node_groups = {
        group1 = {
          node_instance_type = "t3.medium"
          desired_size       = 2
          min_size           = 1
          max_size           = 3
        }
    }
  }
 
}

