data aws_iam_policy_document codebuild_assume_role_policy_document {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource aws_iam_role codebuild_role {
  name               = var.codebuild_role_name
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy_document.json
  tags               = merge(local.default_tags, map("Name", var.codebuild_role_name))
}

data aws_caller_identity self {}

data aws_region current {}

data aws_iam_policy_document codebuild_role_policy_document {
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

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterfacePermission"
    ]
    resources = ["arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.self.account_id}:network-interface/*"]
    condition {
      test     = "StringEquals"
      variable = "ec2:Subnet"
      values = [
        "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.self.account_id}:subnet/${var.private_subnet_a_id}",
        "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.self.account_id}:subnet/${var.private_subnet_c_id}"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "ec2:AuthorizedService"
      values   = ["codebuild.amazonaws.com"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:Get*",
      "s3:List*",
      "s3:DeleteObject"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "lambda:UpdateFunctionCode"
    ]
    resources = ["*"]
  }
}

resource aws_iam_role_policy codebuild_role_policy_attachment {
  role   = aws_iam_role.codebuild_role.id
  policy = data.aws_iam_policy_document.codebuild_role_policy_document.json
}

resource aws_codebuild_project codebuild {
  name          = var.codebuild_project_name
  build_timeout = "30" # TODO
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type    = var.environment_compute_type
    image           = var.environment_image
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  vpc_config {
    vpc_id = var.vpc_id

    subnets = [
      var.private_subnet_a_id,
      var.private_subnet_c_id,
    ]

    security_group_ids = [
      var.codebuild_security_group_id
    ]
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.buildspec
  }
}
