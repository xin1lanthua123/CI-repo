# Tạo file policy định nghĩa quyền truy cập
cat << EOF > eso-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAccessToSecretsManager",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:ListSecrets",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds"
            ],
            "Resource": "*"
        }
    ]
}
EOF

# Tạo policy trên AWS
export POLICY_ARN=$(aws iam create-policy \
    --policy-name datnx-eks-staging-ESOPolicy \
    --policy-document file://eso-policy.json \
    --query 'Policy.Arn' --output text)

echo "Policy ARN: $POLICY_ARN"


# Tạo Service Account gắn kèm IAM Role thông qua eksctl
eksctl create iamserviceaccount \
    --name external-secrets \
    --namespace external-secrets \
    --cluster datnx-eks-staging \
    --role-name datnx-eks-staging-ESORole
    --attach-policy-arn $POLICY_ARN \
    --approve \
    --override-existing-serviceaccounts

