terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_iam_user" "this" {
  name = var.user_name
  tags = { Project = "iam-user-automation" }
}

resource "aws_iam_policy" "s3_read" {
  name        = "${var.user_name}-s3-read"
  description = "Read-only access to S3"
  policy      = var.s3_read_policy
}

resource "aws_iam_user_policy_attachment" "attach" {
  user       = aws_iam_user.this.name
  policy_arn = aws_iam_policy.s3_read.arn
}