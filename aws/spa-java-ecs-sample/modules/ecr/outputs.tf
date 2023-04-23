output ecr_repository_name {
  value = aws_ecr_repository.ecr.name
}

output ecr_repository_url {
  value = join("", aws_ecr_repository.ecr.*.repository_url)
}
