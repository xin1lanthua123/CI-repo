#!/bin/bash
set -euo pipefail

echo "Checking terragrunt output"
if ! terragrunt run-all output -raw > /dev/null 2>&1 ; then

    NAME=("vpc" "eks_core" "aws-secret-manager" 
    "WAF" "S3-Backup-logs" "RDS" "irsa")
    echo "No output is displayed. Start processing each resource application."
    for name in "${NAME[@]}" ; do 
        echo "Applying $NAME"
        terragrunt apply --terragrunt-working-dir $name -auto-approve --terragrunt-non-interactive
        if [ $? -ne 0 ] ; then
            echo "failed to apply at $name"
            exit 1
        fi
    done
else
    "Apply all"
    terragrunt run-all apply  -auto-approve --terragrunt-non-interactive
    if ! terragrunt run-all apply -auto-approve --terragrunt-non-interactive ; then
        echo "Failed to apply all"
        exit 1
    fi
fi
echo "Done"

   



