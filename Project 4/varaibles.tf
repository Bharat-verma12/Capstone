variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "user_name" {
  description = "Name of the IAM user to create"
  type        = string
  default     = "s3-readonly-user"
}

variable "s3_read_policy" {
  description = "S3 read-only policy document stored as a variable (JSON)"
  type        = string
  default     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:ListBucket", "s3:ListAllMyBuckets"],
      "Resource": "*"
    }
  ]
}
EOF
}