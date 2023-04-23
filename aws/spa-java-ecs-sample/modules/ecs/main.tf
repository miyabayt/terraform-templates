resource aws_cloudwatch_log_group log_group {
  name              = var.cloudwatch_log_group_name
  retention_in_days = var.cloudwatch_logs_retention_in_days
  tags              = merge(local.default_tags, map("Name", var.cloudwatch_log_group_name))
}

data aws_iam_policy_document ecs_task_execution_role_policy_document {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource aws_iam_role ecs_task_execution_role {
  name               = var.ecs_task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role_policy_document.json
  tags               = merge(local.default_tags, map("Name", var.ecs_task_execution_role_name))
}

data aws_iam_policy ecs_task_execution_policy {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource aws_iam_role_policy_attachment ecs_task_execution_role_policy_attachment {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_policy.arn
}

data aws_caller_identity self {}
data aws_region current {}

data aws_iam_policy_document ecs_ssm_policy_document {
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.self.account_id}:parameter/*"
    ]
  }
}

resource aws_iam_role_policy ecs_ssm_policy_attachment {
  role   = var.ecs_task_execution_role_name
  policy = data.aws_iam_policy_document.ecs_ssm_policy_document.json
}

data aws_iam_policy_document ecs_task_role_policy_document {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource aws_iam_role ecs_task_role {
  name               = var.ecs_task_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role_policy_document.json
  tags               = merge(local.default_tags, map("Name", var.ecs_task_role_name))
}

data aws_iam_policy_document cloudwatch_policy_document {
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:PutMetricData"
    ]
    resources = [
      "*"
    ]
  }
}

resource aws_iam_role_policy cloudwatch_policy_attachment {
  role   = var.ecs_task_role_name
  policy = data.aws_iam_policy_document.cloudwatch_policy_document.json
}

resource aws_security_group ecs_service_security_group {
  name   = var.ecs_service_security_group_name
  vpc_id = var.vpc_id
}

resource aws_security_group_rule ecs_security_group_rule_ingress {
  security_group_id        = aws_security_group.ecs_service_security_group.id
  type                     = "ingress"
  from_port                = var.host_port
  to_port                  = var.host_port
  protocol                 = "tcp"
  source_security_group_id = var.alb_security_group_id
}

resource aws_security_group_rule ecs_security_group_rule_ingress2 {
  security_group_id = aws_security_group.ecs_service_security_group.id
  type              = "ingress"
  from_port         = var.host_port
  to_port           = var.host_port
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr_block]
}

resource aws_security_group_rule ecs_security_group_rule_egress {
  security_group_id = aws_security_group.ecs_service_security_group.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource aws_ecs_cluster ecs_cluster {
  name = var.ecs_cluster_name
  tags = merge(local.default_tags, map("Name", var.ecs_cluster_name))

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  container_name = var.container_name
}

resource aws_ecs_task_definition ecs_task_definition {
  family                   = var.ecs_task_definition_family
  container_definitions    = var.taskdefinition.rendered
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  requires_compatibilities = ["FARGATE"]
  tags                     = merge(local.default_tags, map("Name", var.ecs_task_definition_family))
}

resource aws_ecs_service ecs_service {
  name                              = var.ecs_service_name
  cluster                           = aws_ecs_cluster.ecs_cluster.name
  task_definition                   = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count                     = var.container_desired_count
  launch_type                       = "FARGATE"
  scheduling_strategy               = "REPLICA"
  health_check_grace_period_seconds = 60

  network_configuration {
    subnets         = var.ecs_service_subnets
    security_groups = [aws_security_group.ecs_service_security_group.id]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  lifecycle {
    # https://www.terraform.io/docs/providers/aws/r/ecs_service.html#ignoring-changes-to-desired-count
    ignore_changes = [desired_count, task_definition]
  }
}

resource aws_appautoscaling_target application_autoscaling_target {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.application_autoscaling_min_capacity
  max_capacity       = var.application_autoscaling_max_capacity
}

resource aws_appautoscaling_policy application_autoscaling_scaleout_policy {
  name               = var.application_autoscaling_scaleout_policy_name
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 600
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.application_autoscaling_target]
}

resource aws_appautoscaling_policy application_autoscaling_scalein_policy {
  name               = var.application_autoscaling_scalein_policy_name
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 600
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.application_autoscaling_target]
}

resource aws_cloudwatch_metric_alarm ecs_service_alarm_high {
  alarm_name          = var.ecs_service_alarm_high_name
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "60" # TODO

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  alarm_actions = [aws_appautoscaling_policy.application_autoscaling_scaleout_policy.arn]
}

resource aws_cloudwatch_metric_alarm ecs_service_alarm_low {
  alarm_name          = var.ecs_service_alarm_low_name
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "30" # TODO

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  alarm_actions = [aws_appautoscaling_policy.application_autoscaling_scalein_policy.arn]
}
