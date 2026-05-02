

resource "aws_iam_role" "externaldns_irsa" {
  count = var.enable_dns_external ? 1 : 0
  name = "${var.cluster_name}-externaldns-irsa"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = var.oidc_provider_arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.oidc_host}:sub" = "system:serviceaccount:kube-system:${var.external_dns_sa}",
            "${local.oidc_host}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "externaldns_policy" {
  count = var.enable_dns_external ? 1 : 0
  name        = "${var.cluster_name}-externaldns-policy"
  description = "Allow ExternalDNS to manage Route53 DNS records"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # ExternalDNS needs to list zones and records
      {
        Effect = "Allow",
        Action = [
          "route53:ListHostedZones",
          "route53:ListHostedZonesByName",
          "route53:ListResourceRecordSets"
        ],
        Resource = "*"
      },

      # Allow changes only on specific hosted zones
      {
        Effect = "Allow",
        Action = [
          "route53:ChangeResourceRecordSets"
        ],
        # Resource = var.route53_zone_arns
        Resource = ["*"]
      } 
    ]
  })
}

resource "aws_iam_role_policy_attachment" "externaldns_attach" {
  role       = aws_iam_role.externaldns_irsa[0].name
  policy_arn = aws_iam_policy.externaldns_policy[0].arn
}
