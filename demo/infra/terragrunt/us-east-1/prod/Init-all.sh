#!/bin/bash
set -euo pipefail

echo "Checking terragrunt init state"

if ! terragrunt run-all init -input=false > /dev/null 2>&1; then

    echo "Init not completed. Start initializing each resource."

    NAMES=(
        "vpc"
        "eks_core"
        "aws-secret-manager"
        "WAF"
        "S3-Backup-logs"
        "RDS"
        "irsa"
    )

    for name in "${NAMES[@]}"; do
        echo "Initializing $name"

        terragrunt init \
            --terragrunt-working-dir "$name" \
            -input=false
    done

else
    echo "Init all"

    terragrunt run-all init -input=false
fi

echo "🎉 Init Done"