resource aws_iam_group codecommit_iam_group {
  name = var.codecommit_iam_group_name
}

resource aws_iam_group_policy_attachment codecommit_iam_group_policy_attachment {
  group      = aws_iam_group.codecommit_iam_group.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}

resource aws_codecommit_repository codecommit_repository {
  repository_name = var.codecommit_repository_name
}
