
terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket       = "capstone-project18-tfstate-590507089733"
    key          = "project18/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "gitops_bucket" {
  bucket_prefix = "capstone-project18-gitops-"

  tags = {
    Name      = "Project18-GitOps"
    Project   = "Capstone"
    ManagedBy = "Terraform"
  }
}

