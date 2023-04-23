resource aws_ssm_parameter ssm_parameters {
  for_each = var.ssm_secrets
  name     = each.key
  type     = "SecureString"
  value    = each.value
}
