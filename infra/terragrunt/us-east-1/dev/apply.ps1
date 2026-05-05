$ErrorActionPreference = "SilentlyContinue"

terragrunt run-all output -raw > $null 2>&1
$ERROR = $LASTEXITCODE

if ($ERROR -ne 0){

    Write-Host "No output is displayed. Start processing each resource application."

    $dirs = @(
        "vpc",
        "eks_core",
        "aws-secret-manager",
        "WAF",
        "S3-Backup-logs",
        "RDS",
        "irsa"
    )

    foreach ($dir in $dirs) {
        Write-Host "Deploy $dir"

        terragrunt apply `
            --terragrunt-working-dir $dir `
            -auto-approve `
            --terragrunt-non-interactive

        if ($LASTEXITCODE -ne 0) {
            Write-Host "Failed at $dir"
            exit 1
        }
    }

} else {

    Write-Host "Deploy all"

    terragrunt run-all apply `
        -auto-approve `
        --terragrunt-non-interactive
}

Write-Host "🎉 DONE"