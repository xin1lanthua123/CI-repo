resource "aws_iam_policy" "github_actions_infra_policy" {
  name        = "${var.project_name}-github-actions-policy"
  description = "GitHub Actions bootstrap + Terraform infra access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
    Sid    = "IAMIRSAAccess",
    Effect = "Allow",
    Action = [

        # Roles for IRSA
        "iam:CreateRole",
        "iam:DeleteRole",
        "iam:GetRole",
        "iam:TagRole",

        # Policies for IRSA
        "iam:CreatePolicy",
        "iam:DeletePolicy",
        "iam:GetPolicy",
        "iam:CreatePolicyVersion",
        "iam:DeletePolicyVersion",
        "iam:TagPolicy",

        # Attach/detach policies
        "iam:AttachRolePolicy",
        "iam:DetachRolePolicy",
        "iam:PutRolePolicy",
        "iam:DeleteRolePolicy",

        # REQUIRED for EKS IRSA
        "iam:PassRole"

    ],
    Resource = "*",
     Condition = {
    StringEquals = {
      "iam:PassedToService" = "eks.amazonaws.com"
    }
  }
    },
      # S3 Backup logs
   
     {
        Sid    = "S3LogsAndBackup",
        Effect = "Allow",
        Action = [
            "s3:CreateBucket",
            "s3:DeleteBucket",
            "s3:PutBucketVersioning",
            "s3:PutBucketEncryption",
            "s3:PutBucketLogging",
            "s3:PutLifecycleConfiguration",
            "s3:ListBucket"
        ],
        Resource = "arn:aws:s3:::my-log-bucket"
        },
        {
        Sid    = "S3LogBucketObjects",
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        Resource = "arn:aws:s3:::my-log-bucket/*"
      },
       {
        Sid    = "KMSforS3BackUpLogs",
        Effect = "Allow",
        Action = [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:GenerateDataKey",
            "kms:DescribeKey"
        ],
         Resource = "*"
    },

   

  
      # RDS 
  
      {
        Sid    = "RDSAccess",
        Effect = "Allow",
        Action = [
          "rds:CreateDBInstance",
          "rds:ModifyDBInstance",
          "rds:DeleteDBInstance",
          "rds:DescribeDBInstances",
          "rds:CreateDBSubnetGroup",
          "rds:DeleteDBSubnetGroup"
        ],
        Resource = "*"
      },

     
      # Secrets Manager
    
      {
        Sid    = "SecretsManagerAccess",
        Effect = "Allow",
        Action = [
          "secretsmanager:CreateSecret",
          "secretsmanager:UpdateSecret",
          "secretsmanager:DeleteSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:TagResource"
        ],
        Resource = "*"
      },

     
      # VPC / EC2 
      
      {
        Sid    = "VPCAccess",
        Effect = "Allow",
        Action = [
          "ec2:CreateVpc",
          "ec2:DeleteVpc",
          "ec2:DescribeVpcs",

          "ec2:CreateSubnet",
          "ec2:DeleteSubnet",
          "ec2:DescribeSubnets",

          "ec2:CreateRouteTable",
          "ec2:DeleteRouteTable",
          "ec2:DescribeRouteTables",

          "ec2:AssociateRouteTable",

          "ec2:CreateInternetGateway",
          "ec2:AttachInternetGateway",
          "ec2:DeleteInternetGateway",

          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress"
        ],
        Resource = "*"
      },

 
      # EKS 
   
      {
        Sid    = "EKSAccess",
        Effect = "Allow",
        Action = [
          "eks:CreateCluster",
          "eks:DeleteCluster",
          "eks:DescribeCluster",
          "eks:UpdateClusterConfig",
          "eks:UpdateClusterVersion",

          "eks:CreateNodegroup",
          "eks:DeleteNodegroup",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:ListClusters"
        ],
        Resource = "*"
      },


      # WAF
    
      {
        Sid    = "WAFAccess",
        Effect = "Allow",
        Action = [
          "wafv2:CreateWebACL",
          "wafv2:ListWebACLs",
          "wafv2:DeleteWebACL",
          "wafv2:UpdateWebACL",
          "wafv2:GetWebACL",
          "wafv2:AssociateWebACL"
        ],
        Resource = "*"
      },

  
      # Route53
     
      {
        Sid    = "Route53Access",
        Effect = "Allow",
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:GetHostedZone",
          "route53:ListResourceRecordSets",
          "route53:ListHostedZones"
        ],
        Resource = "*"
      },

      # ACM
    
      {
        Sid    = "ACMAccess",
        Effect = "Allow",
        Action = [
          "acm:RequestCertificate",
          "acm:DeleteCertificate",
          "acm:DescribeCertificate",
          "acm:ListCertificates"
        ],
        Resource = "*"
      }

    ]
  })
}