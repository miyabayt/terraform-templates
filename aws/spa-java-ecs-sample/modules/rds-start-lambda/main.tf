
data aws_iam_policy_document lambda_role_policy_document {
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
  name               = local.lambda_role_name
  assume_role_policy = data.aws_iam_policy_document.lambda_role_policy_document.json
  tags               = merge(local.default_tags, map("Name", local.lambda_role_name))
}

data aws_iam_policy_document lambda_policy_document {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "rds:StartDBCluster",
      "rds:StopDBCluster"
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource aws_iam_role_policy lambda_policy_attachment {
  role   = aws_iam_role.lambda_role.name
  policy = data.aws_iam_policy_document.lambda_policy_document.json
}

data archive_file rds_start_lambda {
  type        = "zip"
  source_file = "../../modules/rds-start-lambda/index.js"
  output_path = "../../modules/rds-start-lambda/rds-start-lambda.zip"
}

resource aws_lambda_function rds_start_lambda {
  filename         = data.archive_file.rds_start_lambda.output_path
  function_name    = "start-rds-cluster"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.rds_start_lambda.output_base64sha256
  runtime          = "nodejs12.x"
}
