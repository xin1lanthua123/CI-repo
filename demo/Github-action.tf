# data "aws_caller_identity" "current" {}
# data "tls_certificate" "github" {
#   url = "https://token.actions.githubusercontent.com"
# }
# resource "aws_iam_openid_connect_provider" "github" {
#   url = "https://token.actions.githubusercontent.com"

#   client_id_list = ["sts.amazonaws.com"]

#   thumbprint_list = [for cert in data.tls_certificate.github.certificates: cert.sha1_fingerprint]
# }
# resource "aws_iam_role" "github_actions" {
#   name = "${var.project_name}-github-actions-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect = "Allow",
#       Principal = {
#         Federated = aws_iam_openid_connect_provider.github.arn
#       },
#       Action = "sts:AssumeRoleWithWebIdentity",
#         Condition = {
#         StringEquals = {
#           "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
#           "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:environment:${var.environment}"
#         }
#       }
      
#     }]
#   })
# }
# resource "aws_iam_role_policy_attachment" "attach" {
#   role       = aws_iam_role.github_actions.name
#   policy_arn = aws_iam_policy.github_actions_policy.arn
# }
# #IAM Policy (S3 + KMS + Terraform State)

# resource "aws_iam_policy" "github_actions_policy" {
#   name        = "${var.project_name}-github-actions-policy"
#   description = "GitHub Actions deploy access to AWS infrastructure"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [

#       # S3
     
#       {
#         Sid    = "S3StateAccess",
#         Effect = "Allow",
#         Action = [
#           "s3:ListBucket",
#           "s3:GetObject",
#           "s3:PutObject",
#           "s3:DeleteObject"
#         ],
#         Resource =  [
#           var.bucket_tfstate_arn,
#           "${bucket_tfstate_arn}/*"
#         ]
#       },

   
#       # DynamoDB (state lock + app)
    
#       {
#         Sid    = "DynamoDBAccess",
#         Effect = "Allow",
#         Action = [
#           "dynamodb:DescribeTable",
#           "dynamodb:PutItem",
#           "dynamodb:GetItem",
#           "dynamodb:UpdateItem",
#           "dynamodb:DeleteItem"
#         ],
#         Resource = var.lock_table_arn
#       },

   
#       # RDS (DB deploy/manage)
    
#       {
#         Sid    = "RDSAccess",
#         Effect = "Allow",
#         Action = [
#           "rds:CreateDBInstance",
#           "rds:ModifyDBInstance",
#           "rds:DeleteDBInstance",
#           "rds:DescribeDBInstances",
#           "rds:CreateDBSubnetGroup",
#           "rds:DeleteDBSubnetGroup"
#         ],
#         Resource = var.rds_instance_arn
#       },

#       # Secrets Manager
    
#       {
#         Sid    = "SecretsManagerAccess",
#         Effect = "Allow",
#         Action = [
#           "secretsmanager:CreateSecret",
#           "secretsmanager:UpdateSecret",
#           "secretsmanager:DeleteSecret",
#           "secretsmanager:GetSecretValue",
#           "secretsmanager:DescribeSecret",
#           "secretsmanager:TagResource"
#         ],
#         Resource = var.secrets_manager_arns
#       },

   
#       # VPC (network infra)
   
#       {
#         Sid    = "VPCAccess",
#         Effect = "Allow",
#         Action = [
#           "ec2:CreateVpc",
#           "ec2:DeleteVpc",
#           "ec2:DescribeVpcs",
#           "ec2:CreateSubnet",
#           "ec2:DeleteSubnet",
#           "ec2:DescribeSubnets",
#           "ec2:CreateRouteTable",
#           "ec2:DeleteRouteTable",
#           "ec2:DescribeRouteTables",
#           "ec2:AssociateRouteTable",
#           "ec2:CreateInternetGateway",
#           "ec2:AttachInternetGateway",
#           "ec2:DeleteInternetGateway",
#           "ec2:CreateSecurityGroup",
#           "ec2:DeleteSecurityGroup",
#           "ec2:AuthorizeSecurityGroupIngress",
#           "ec2:AuthorizeSecurityGroupEgress"
#         ],
#         Resource = "*"
#       },

   
#       # EKS (Kubernetes deploy)
   
#       {
#         Sid    = "EKSAccess",
#         Effect = "Allow",
#         Action = [
#           "eks:CreateCluster",
#           "eks:DescribeCluster",
#           "eks:CreateNodegroup",
#           "eks:DescribeNodegroup"
#         ],
#         Resource = var.eks_cluster_arn
#       },
#        {
#         Sid    = "EKSAccess",
#         Effect = "Allow",
#         Action = [
#           "eks:CreateCluster",
#           "eks:DeleteCluster",
#           "eks:DescribeCluster",
#           "eks:ListClusters",
#           "eks:UpdateClusterConfig",
#           "eks:UpdateClusterVersion",
#           "eks:CreateNodegroup",
#           "eks:DeleteNodegroup",
#           "eks:DescribeNodegroup"
#         ],
#         Resource = var.eks_cluster_arn
#       },

    
#       # WAF
#       {
#         Sid    = "WAFAccess",
#         Effect = "Allow",
#         Action = [
#           "wafv2:CreateWebACL",
#           "wafv2:DeleteWebACL",
#           "wafv2:UpdateWebACL",
#           "wafv2:GetWebACL",
#           "wafv2:ListWebACLs",
#           "wafv2:AssociateWebACL"
#         ],
#         Resource = var.aws_wafv2_web_acl_arn
#       },

#       # Route53 + ACM
    
#       {
#         Sid    = "Route53ACMAccess",
#         Effect = "Allow",
#         Action = [
#           "route53:ChangeResourceRecordSets",
#           "route53:ListHostedZones",
#           "route53:ListResourceRecordSets",
#           "route53:GetHostedZone",
#           "acm:RequestCertificate",
#           "acm:DescribeCertificate",
#           "acm:ListCertificates",
#           "acm:DeleteCertificate"
#         ],
#         Resource = var.route53_zone_arns
#       }

#     ]
#   })
#   depends_on = [ aws_s3_bucket.tf_state ]
# }
 
# data "aws_iam_policy_document" "kms" {

#   statement {
#     sid = "AllowRootAccess"
#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
#     }

#     actions = ["kms:*"]

#     resources = ["*"]
#   }

#   statement {
#     sid = "AllowTerraformRoleUseOfKey"
#     effect = "Allow"

#     principals {
#     type = "AWS"
#     identifiers = [aws_iam_role.github_actions.arn]
# }

#     actions = [
#       "kms:Encrypt",
#       "kms:Decrypt",
#       "kms:GenerateDataKey",
#       "kms:DescribeKey"
#     ]

#     resources = ["*"]
#   }
# }

# resource "aws_kms_key_policy" "this" {
#   key_id = aws_kms_key.tf_state[0].arn
#   policy = data.aws_iam_policy_document.kms.json
# }