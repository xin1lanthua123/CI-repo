$ErrorActionPreference = "Stop"

Write-Host "Init VPC"
terragrunt init --terragrunt-working-dir vpc -input=false

Write-Host "Init EKS Core"
terragrunt init --terragrunt-working-dir eks_core -input=false

Write-Host "Init AWS Secret Manager"
terragrunt init --terragrunt-working-dir aws-secret-manager -input=false

Write-Host "Init WAF"
terragrunt init --terragrunt-working-dir WAF -input=false

Write-Host "Init S3 Backup Logs"
terragrunt init --terragrunt-working-dir S3-Backup-logs -input=false

Write-Host "Init RDS"
terragrunt init --terragrunt-working-dir RDS -input=false


Write-Host "Init IRSA"
terragrunt init --terragrunt-working-dir irsa -input=false

Write-Host "🎉 Init Done"

terragrunt init -migrate-state -force-copy -terragrunt-non-interactive     