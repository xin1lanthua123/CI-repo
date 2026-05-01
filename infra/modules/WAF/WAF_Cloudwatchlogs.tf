resource "aws_cloudwatch_log_group" "waf_logs" {
  name              = "aws-waf-logs-${var.project_name}-${var.env}"
  retention_in_days = 14

  tags = merge(var.tags,{
    Project     = var.project_name
  })
}
resource "aws_wafv2_web_acl_logging_configuration" "this" {
  resource_arn            = aws_wafv2_web_acl.this.arn
  log_destination_configs = [
    "${aws_cloudwatch_log_group.waf_logs.arn}"
]
}

resource "aws_cloudwatch_log_resource_policy" "waf_log_policy" {
  policy_name = "${var.project_name}-waf-log-policy"

  policy_document = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AWSWAFLogsToCloudWatch",
        Effect = "Allow",
        Principal = {
          Service = "waf.amazonaws.com"
        },
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "${aws_cloudwatch_log_group.waf_logs.arn}:*"
      }
    ]
  })
}