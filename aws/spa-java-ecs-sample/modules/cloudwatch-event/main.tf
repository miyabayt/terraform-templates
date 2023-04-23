resource aws_cloudwatch_event_rule event_rule {
  name                = var.rule_name
  schedule_expression = var.schedule_expression
}

resource aws_cloudwatch_event_target event_target {
  rule  = aws_cloudwatch_event_rule.event_rule.name
  arn   = var.event_target_arn
  input = var.input
}

resource aws_lambda_permission lambda_permission {
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event_rule.arn
}
