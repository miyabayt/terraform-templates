resource aws_ssm_parameter ssm_parameter {
  for_each = var.ssm_secrets
  name     = each.key
  type     = "SecureString"
  value    = each.value
}
