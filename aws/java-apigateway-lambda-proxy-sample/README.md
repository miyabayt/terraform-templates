# java-apigateway-lambda-proxy-sample

## 概要

以下のAWSサービスを作成するテンプレートです。

- アプリケーション実行基盤
  - API Gateway
  - Lambda (Custom Runtime)
- ミドルウェア
  - Secrets Manager
  - SSM parameter store
  - RDS Aurora @ MySQL 5.7
  - RDS Proxy
- ネットワーク
  - VPC @ Private & Public Subnet
  - Nat Gateway + EIP
- ビルド
  - CodePipeline
  - CodeCommit
  - CodeBuild

## 前提条件

- Javaアプリケーション
  - Gradle でビルドできること

## ディレクトリ構成

- envs・・・各環境ごとのテンプレートを配置する
  - dev
    - java-app
    - middleware
    - network
- modules・・・環境に依存しない汎用的なモジュールを配置する
  - apigateway
  - codebuild
  - codecommit
  - codepipeline
  - lambda
  - rds
  - rdsproxy
  - secretsmanager
  - ssm
  - vpc

## 使い方

### 変数の整理

以下のファイルに定義された設定値を修正してください。

1. envs/dev/app/variables.tf
1. envs/dev/terraform.tfvars.tpl
    - .tplファイルを参考に envs/dev/terraform.tfvars ファイルを作成してください。

### 初回実行コマンド

```bash
# ベースディレクトリへ移動する
$ cd /path/to/terraform-samples/java-apigateway-lambda-proxy-sample

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
