output secret_arn {
  value = aws_secretsmanager_secret_version.secret_version.arn
}
