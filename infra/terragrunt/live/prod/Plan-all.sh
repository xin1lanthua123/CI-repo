#!/bin/bash
set -euo pipefail

echo "Checking terragrunt output"
if ! terragrunt run-all output -raw > /dev/null 2>&1 ; then
    NAME=("vpc" "eks_core" "aws-secret-manager" 
    "WAF" "S3-Backup-logs" "RDS" "irsa")
    echo "No output is displayed. Start processing each resource application."
    for name in "${NAME[@]}" ; do 
        echo "Applying $NAME"
        terragrunt plan --terragrunt-working-dir "$name"
        if [ $? -ne 0 ] ; then
            echo "failed to plan at $name"
            exit 1
        fi
    done
else
    terragrunt run-all plan 
    if [ $? -ne 0 ]; then
        echo "failed to plan all"
        exit 1
    fi
fi
echo "Done"

