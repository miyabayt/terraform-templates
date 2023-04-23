output codebuild_project_name {
  value = aws_codebuild_project.codebuild.name
}

output codebuild_role_arn {
  value = aws_iam_role.codebuild_role.arn
}

output artifact_s3_bucket_arn {
  value = "value"
}
