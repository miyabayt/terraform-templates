locals {
  default_tags = {
    createdBy = "terraform"
  }
}

# s3
variable artifact_s3_bucket_name {}
variable artifact_s3_bucket_arn {}

# codecommit
variable codecommit_repository_name {}
variable codecommit_branch_name {}

# codepipeline
variable codepipeline_name {}
variable codepipeline_role_name {}
variable codepipeline_project_name {}

# ecs
variable ecs_cluster_name {}
variable ecs_service_name {}
