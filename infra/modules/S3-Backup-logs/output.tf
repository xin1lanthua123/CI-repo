output "s3_bucket_id" {
  value = aws_s3_bucket.logs.id
}
output "s3_bucket_arn" {
  value = aws_s3_bucket.logs.arn
}
output "s3_regional_domain_name"{
  value = aws_s3_bucket.logs.bucket_regional_domain_name
}
