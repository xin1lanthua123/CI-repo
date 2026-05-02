locals {
  tags = {
    env          = "dev"
    Project      = "my-app"
    ManagedBy    = "terraform"
  }
  service_accounts = {
    alb_service_account  = "aws-load-balancer-controller"
  }
  S3_logs = {
    enable_kms = true
  }
  vpc = {
    single_nat_gateway = true
  }
  rds = {
    engine_version = "15"
    multi_az = false
    instance_class = "db.t3.micro"
    db_name = "devpostgresdb"
    db_username = "devmyappdb"
  }
  eks = {
      cluster_version = "1.30"
      enable_irsa = true
      node_groups = {
        group1 = {
          node_instance_type = "t3.micro"
          desired_size       = 2
          min_size           = 1
          max_size           = 3
        }
    }
  }
  irsa = {
    domain_name           = "quanldl.uk"
    region                = "us-east-1"
    enable_alb_controller = true
    enable_dns_external   = true
    enable_ebs_csi_driver = true
    enable_eso            = true
    enable_karpenter      = true
  }
}

