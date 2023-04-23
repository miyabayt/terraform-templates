resource aws_cloudwatch_log_group log_group {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = var.cloudwatch_logs_retention_in_days
  tags              = local.default_tags
}

data aws_iam_policy_document lambda_assume_role_policy_document {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource aws_iam_role lambda_role {
  name               = var.lambda_role_name
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy_document.json
  tags               = merge(local.default_tags, map("Name", var.lambda_role_name))
}

data aws_caller_identity self {}

data aws_region current {}

data aws_iam_policy_document lambda_role_policy_document {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs"
    ]
    resources = ["*"]
  }
}

resource aws_iam_role_policy lambda_role_policy_attachment {
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_role_policy_document.json
}

data archive_file hello_world_lambda {
  type        = "zip"
  source_file = "../../modules/lambda/index.js"
  output_path = "../../modules/lambda/hello-world-lambda.zip"
}

resource aws_lambda_function lambda {
  filename         = data.archive_file.hello_world_lambda.output_path
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = var.lambda_handler
  source_code_hash = data.archive_file.hello_world_lambda.output_base64sha256
  runtime          = var.lambda_runtime
  memory_size      = var.lambda_memory_size
  timeout          = var.lambda_timeout

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.lambda_security_group_id]
  }

  environment {
    variables = var.lambda_environment_variables
  }

  lifecycle {
    ignore_changes = [
      source_code_hash
    ]
  }
}
