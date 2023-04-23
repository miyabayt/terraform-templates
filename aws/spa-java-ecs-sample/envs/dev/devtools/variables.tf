# common
variable prefix {}

# rds
variable rds_cluster_identifier {}

# cloudwatch event
locals {
  start_rule_schedule_expression = "cron(0 1 * * ? *)"
  stop_rule_schedule_expression  = "cron(0 16 * * ? *)"
}
