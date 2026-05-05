# $ErrorActionPreference = "SilentlyContinue"

# Write-Host "Checking terragrunt output"

# terragrunt run-all output -raw > $null 2>&1
# $ERROR = $LASTEXITCODE

# if ($ERROR -ne 0) {

#     Write-Host "No output is displayed. Start processing each resource plan."

#     Write-Host "Bootstrap VPC"
#     terragrunt plan --terragrunt-working-dir vpc --terragrunt-non-interactive

#     Write-Host "Bootstrap EKS Core"
#     terragrunt plan --terragrunt-working-dir eks_core --terragrunt-non-interactive

#     Write-Host "Deploy AWS-secret-manager"
#     terragrunt plan --terragrunt-working-dir aws-secret-manager --terragrunt-non-interactive

#     Write-Host "Deploy WAF"
#     terragrunt plan --terragrunt-working-dir WAF --terragrunt-non-interactive

#     Write-Host "Deploy S3Logs"
#     terragrunt plan --terragrunt-working-dir S3-Backup-logs --terragrunt-non-interactive

#     Write-Host "Deploy RDS"
#     terragrunt plan --terragrunt-working-dir RDS --terragrunt-non-interactive

#     Write-Host "Deploy IRSA"
#     terragrunt plan --terragrunt-working-dir irsa --terragrunt-non-interactive

# } else {

#     Write-Host "Plan all"
#     terragrunt run-all plan --terragrunt-non-interactive
# }

# Write-Host "🎉 DONE"
$dirs = @(
  "vpc",
  "eks_core",
  "aws-secret-manager",
  "WAF",
  "S3-Backup-logs",
  "RDS",
  "irsa"
)

Write-Host "Running plans..."

foreach ($dir in $dirs) {
    Write-Host "Planning $dir"
    terragrunt plan --terragrunt-working-dir $dir --terragrunt-non-interactive
}