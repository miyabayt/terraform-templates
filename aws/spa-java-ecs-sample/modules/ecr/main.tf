resource aws_ecr_repository ecr {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = merge(local.default_tags, map("Name", var.ecr_repository_name))
}

data aws_iam_policy_document ecr_repository_policy_document {
  statement {
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
  }
}

resource aws_ecr_repository_policy ecr_repository_policy {
  repository = aws_ecr_repository.ecr.name
  policy     = data.aws_iam_policy_document.ecr_repository_policy_document.json
}
