output "rds_instance_arn" {
  value = aws_db_instance.postgres.arn
}
output "db_name" {
  value = aws_db_instance.postgres.db_name
}
output "username" {
  value = aws_db_instance.postgres.username
}
