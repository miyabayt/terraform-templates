resource aws_secretsmanager_secret secret {
  name                    = var.secret_name
  recovery_window_in_days = 0
}

resource aws_secretsmanager_secret_version secret_version {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode(var.secret_string)
}
