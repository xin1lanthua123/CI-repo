locals {
  bootstrap = {
   region       = "us-east-1"
   enable_kms   = true
   project_name = "myapp"
   github_org   = "xin1lanthua123"
   github_repo  = "CI-repo"
   env          = "prod"
  }
 
}
