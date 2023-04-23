data aws_iam_policy_document rds_proxy_policy_document {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

resource aws_iam_role rds_proxy_role {
  name               = var.rds_proxy_role_name
  assume_role_policy = data.aws_iam_policy_document.rds_proxy_policy_document.json
}

resource aws_iam_role_policy rds_proxy_policy {
  name   = var.rds_proxy_policy_name
  role   = aws_iam_role.rds_proxy_role.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds"
      ],
      "Resource": "arn:aws:secretsmanager:*:*:*"
    }
  ]
}
POLICY
}

resource aws_db_proxy rds_proxy {
  name                   = var.rds_proxy_name
  engine_family          = var.rds_engine_family
  role_arn               = aws_iam_role.rds_proxy_role.arn
  vpc_security_group_ids = [var.rds_proxy_security_group_id]
  vpc_subnet_ids         = var.db_subnet_ids

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "DISABLED"
    secret_arn  = var.secret_arn
  }
}

resource aws_db_proxy_default_target_group rds_proxy_default_target_group {
  db_proxy_name = aws_db_proxy.rds_proxy.name
}

resource aws_db_proxy_target rds_proxy_target {
  db_cluster_identifier = var.rds_proxy_target_id
  db_proxy_name         = aws_db_proxy.rds_proxy.name
  target_group_name     = "default"
}
