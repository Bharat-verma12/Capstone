output "user_arn" {
  value = aws_iam_user.this.arn
}

output "policy_arn" {
  value = aws_iam_policy.s3_read.arn
}