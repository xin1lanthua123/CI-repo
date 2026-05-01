output "route53_domain_name" {
  value = aws_route53_zone.main.name
}
output "route53_zone_arns" {
  value = aws_route53_zone.main.arn
}