resource "random_password" "db" {
  length  = 8
  special = true
  override_special = "!#$%^&*()-_=+[]{};:,.<>?"
}
resource "random_id" "name" {
  byte_length = 4
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "${var.project_name}/${var.env}/rds/postgres-${random_id.name.hex}"
  recovery_window_in_days = 7
}
locals {
  secret = { username = var.username
    password = random_password.db.result
    dbname = var.db_name
}
}
resource "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode(local.secret)
}