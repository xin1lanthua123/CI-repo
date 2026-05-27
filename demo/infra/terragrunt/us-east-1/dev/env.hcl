
locals {
  kms_tags = { 
    kms_key_alias = "alias/s3-logs-key"
    kms_s3_tags = {
    
    Name        = "dev-s3-logs-kms"
    Project     = "my-app"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
  tags = {
    env          = "dev"
    Project      = "my-app"
    ManagedBy    = "terraform"
  }
  aws_secret_manager = {
    secret_for_rds = {
      db_name = "dev-postgres-db"
      username = "my-app-dev"
      password = "set up in secret manager module"
    }
  }
  irsa = { 
    enable_eks_addons = {
      cluster_name          = "dev-my-app-eks"
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
      ebs_csi_version         = "v1.30.0-eksbuild.1"
      helm_argocd_version     = "7.8.2"
      server_insecure         = true
      external_dns_sa         = "external-dns"
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
    instance_class = "db.t3.micro"
    db_name        = "devpostgresdb"
    db_username    = "devmyappdb"
  }
  eks = {
      cluster_version = "1.30"
      enable_irsa     = true
      node_groups = {
        group1 = {
          node_instance_type = "t3.micro"
          desired_size       = 2
          min_size           = 1
          max_size           = 3
        }
    }
  }
 
}

