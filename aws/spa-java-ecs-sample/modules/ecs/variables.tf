locals {
  default_tags = {
    createdBy = "terraform"
  }
}


# vpc
variable vpc_id {}
variable vpc_cidr_block {}

# alb
variable alb_security_group_id {}
variable target_group_arn {}

# cloudwatch
variable cloudwatch_log_group_name {}
variable cloudwatch_log_stream_prefix {}
variable cloudwatch_logs_retention_in_days {}
variable ecs_service_alarm_low_name {}
variable ecs_service_alarm_high_name {}

# ecs
variable ecs_cluster_name {}
variable ecs_service_name {}
variable container_name {}
variable host_port {}
variable container_port {}
variable container_desired_count {}
variable ecs_service_subnets {}
variable ecs_service_security_group_name {}
variable taskdefinition {}

variable ecs_task_cpu {
  default = "512"
}

variable ecs_task_memory {
  default = "1024"
}

variable ecs_task_definition_family {}
variable ecs_task_execution_role_name {}
variable ecs_task_role_name {}

variable application_autoscaling_min_capacity {}
variable application_autoscaling_max_capacity {}
variable application_autoscaling_scaleout_policy_name {}
variable application_autoscaling_scalein_policy_name {}
