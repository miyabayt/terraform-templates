# aws credentials
aws_region     = "ap-northeast-1"

# common
prefix         = "xxxx"

# vpc
vpc_cidr                    = "10.98.0.0/16"
public_subnet_a_cidr_block  = "10.98.10.0/24"
public_subnet_c_cidr_block  = "10.98.11.0/24"
private_subnet_a_cidr_block = "10.98.20.0/24"
private_subnet_c_cidr_block = "10.98.21.0/24"

# rds
rds_instance_class = "db.t2.small"
rds_port           = 3306
db_name            = "xxxx"
db_user            = "root"
db_password        = "passw0rd"

# cloudwatch
cloudwatch_log_group_name         = "xxxx-app-log-group"
cloudwatch_log_stream_prefix      = "ecs"
cloudwatch_logs_retention_in_days = 7
