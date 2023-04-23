# java-ecs-sample

## 概要

以下のAWSサービスを作成するテンプレートです。

- アプリケーション実行基盤
  - WAF @ Major Rules
  - CloudFront @ Custom Origin (Java Application)
  - ALB
  - ECS Fargate @ Auto Scaling Policy
- ミドルウェア
  - SSM parameter store
  - RDS Aurora @ MySQL 5.7
  - ElastiCache @ Redis Cluster
- ネットワーク
  - VPC @ Private & Public Subnet
  - Nat Gateway + EIP
- ビルド
  - ECR
  - CodePipeline
  - CodeCommit
  - CodeBuild

## 前提条件

- Javaアプリケーション
  - Gradle でビルドできること
  - Gradle Jib プラグインのタスクが実行できること

## ディレクトリ構成

- envs・・・各環境ごとのテンプレートを配置する
  - dev
    - certificate
    - java-app
    - middleware
    - network
  - modules・・・環境に依存しない汎用的なモジュールを配置する
    - alb
    - cloudfront
    - codebuild
    - codecommit
    - codepipeline-ecs
    - ecr
    - ecs
    - elasticache
    - rds
    - ssm
    - vpc
    - waf

## 使い方

### 変数の整理

以下のファイルに定義された設定値を修正してください。

1. envs/dev/app/variables.tf
1. envs/dev/terraform.tfvars.tpl
    - .tplファイルを参考に envs/dev/terraform.tfvars ファイルを作成してください。

### 初回実行コマンド

```bash
# ベースディレクトリへ移動する
$ cd /path/to/terraform-samples/java-ecs-sample

# 開発環境の場合
$ cd envs/dev

# AWSプロファイルを指定する
$ export AWS_PROFILE=my-aws-profile

# 初期化
$ terraform init

# tfstateリフレッシュ
$ terraform refresh

# 実行計画の表示
$ terraform plan

# 実行（反映する）
$ terraform apply

# 破棄
$ terraform destroy
```
