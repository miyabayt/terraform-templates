output ecs_cluster_name {
  value = aws_ecs_cluster.ecs_cluster.name
}

output ecs_service_name {
  value = aws_ecs_service.ecs_service.name
}

output container_name {
  value = local.container_name
}

output ecs_taskdef_family {
  value = aws_ecs_task_definition.ecs_task_definition.family
}

output ecs_task_execution_role_arn {
  value = aws_iam_role.ecs_task_execution_role.arn
}
