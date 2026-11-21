# Project 23: IAM Role-Based Access

## Goal
Secure AWS resource access using an IAM role.

## AWS Services
- AWS IAM
- Amazon EC2
- Amazon S3
- AWS CLI

## Implementation
1. Configured EC2-S3-Access-Role.
2. Attached AmazonS3ReadOnlyAccess policy.
3. Configured EC2-S3-Instance-Profile.
4. Associated the instance profile with EC2.
5. Tested S3 access using AWS CLI.

## EC2 Instance
Instance ID: i-06ad9757a3d3f9f67

## S3 Bucket
bharat-project23-iam-590507089733

## Verification Commands
aws sts get-caller-identity
aws configure list
aws s3 ls s3://bharat-project23-iam-590507089733/

## Deliverables
- IAM role configuration
- EC2 instance profile association
- S3 CLI test output
- Screenshots

## Result
EC2 accessed S3 using an IAM role
without requiring static AWS access keys.
