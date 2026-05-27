resource "aws_wafv2_web_acl" "this" {
  name        = "${var.env}-${var.project_name}-waf"
  description = "WAF for ALB protecting EKS ingress"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "commonRules"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-waf"
    sampled_requests_enabled   = true
  }
  rule {
  name     = "AWSManagedIPReputationList"
  priority = 2

  override_action {
    none {}
  }

  statement {
    managed_rule_group_statement {
      name        = "AWSManagedRulesAmazonIpReputationList"
      vendor_name = "AWS"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "ipReputation"
    sampled_requests_enabled   = true
  }
}
rule {
  name     = "AWSManagedAnonymousIPList"
  priority = 3

  override_action {
    none {}
  }

  statement {
    managed_rule_group_statement {
      name        = "AWSManagedRulesAnonymousIpList"
      vendor_name = "AWS"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "anonymousIp"
    sampled_requests_enabled   = true
  }
}
}

# data "aws_lb" "ingress" {
#   tags = {
#     "elbv2.k8s.aws/cluster" = var.cluster_name
#   }
# }

# resource "aws_wafv2_web_acl_association" "alb" {
#   resource_arn = data.aws_lb.ingress.arn
#   web_acl_arn  = aws_wafv2_web_acl.this.arn
# }