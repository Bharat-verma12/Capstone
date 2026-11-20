# Project 4: IAM User Automation with Terraform

## Goal
Use Terraform to create an AWS IAM user and give it read-only access to Amazon S3. The policy is stored as a variable.

## Tasks
- Create an IAM user
- Create an S3 read-only IAM policy from a JSON policy stored in a variable
- Attach the policy to the user

## Architecture

```
┌──────────────────────────┐        ┌───────────────────────────────┐
│ IAM User                 │        │ IAM Policy                    │
│ s3-readonly-user         │◄───────│ s3-readonly-user-s3-read      │
│ tag: iam-user-automation │ attach │ s3:GetObject                  │
└──────────────────────────┘        │ s3:ListBucket                 │
                                    │ s3:ListAllMyBuckets           │
                                    └───────────────────────────────┘
```

## Resources Created

| Resource | Name | Purpose |
|----------|------|---------|
| `aws_iam_user` | `s3-readonly-user` | IAM user, tagged `Project = iam-user-automation` |
| `aws_iam_policy` | `s3-readonly-user-s3-read` | Customer-managed policy with S3 read-only permissions |
| `aws_iam_user_policy_attachment` | – | Attaches the policy to the user |

## Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `region` | string | `us-east-1` | AWS region for the provider |
| `user_name` | string | `s3-readonly-user` | IAM user name. Also used as the prefix of the policy name |
| `s3_read_policy` | string (JSON) | S3 read-only policy | IAM policy document attached to the user |

### Default policy

```json
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
```

### Overriding variables

To change any variable, set it in `terraform.tfvars`:

```hcl
user_name = "s3-readonly-user"

s3_read_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:ListBucket"],
      "Resource": [
        "arn:aws:s3:::my-bucket",
        "arn:aws:s3:::my-bucket/*"
      ]
    }
  ]
}
EOF
```

## Outputs

| Name | Description |
|------|-------------|
| `user_arn` | ARN of the IAM user |
| `policy_arn` | ARN of the S3 read-only policy |

## Prerequisites
- Terraform version 1.3 or later
- AWS CLI set up with credentials that can manage IAM (`iam:CreateUser`, `iam:CreatePolicy`, `iam:AttachUserPolicy`, and so on)

## Deploy

```powershell
cd "Project 4"
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

Variables are read when you run `terraform plan`. `terraform apply tfplan` uses the values saved in the plan and doesn't accept `-var` or `-var-file`.

## Verify

```powershell
terraform output

aws iam get-user --user-name s3-readonly-user
aws iam list-attached-user-policies --user-name s3-readonly-user
```

## Screenshots

![Project 4 - 1](../outputs%20pics/Project%204/Screenshot%202026-11-19%20235817.png)
![Project 4 - 2](../outputs%20pics/Project%204/Screenshot%202026-11-19%20235840.png)
![Project 4 - 3](../outputs%20pics/Project%204/Screenshot%202026-11-19%20235858.png)
![Project 4 - 4](../outputs%20pics/Project%204/Screenshot%202026-11-20%20000344.png)

## Troubleshooting

| Error | Fix |
|-------|-----|
| `EntityAlreadyExists: User with name s3-readonly-user already exists` | The user exists in AWS, but Terraform's state doesn't include it. Import it with `terraform import aws_iam_user.this s3-readonly-user`, or choose a different `user_name`. Then run `terraform plan` again |
| `Saved plan is stale` | Run `terraform plan -out=tfplan` again before you apply |
| `AccessDenied` on IAM actions | Your AWS credentials need IAM permissions |
| `MalformedPolicyDocument` | Check that `s3_read_policy` is valid JSON with `Version` and `Statement` |

## Clean Up

```powershell
terraform destroy
```

## Security Notes
- The default policy uses `"Resource": "*"`, which gives read access to **every** bucket in the account. For least privilege, limit it to specific bucket ARNs.
- This project creates no access keys or console password. If you add them, never commit them to Git.
- Don't commit `terraform.tfstate`, `*.tfvars` or `tfplan`. They can contain account details.

## File Structure

```
Project 4/
├── main.tf            # Provider, IAM user, policy, attachment
├── varaibles.tf       # region, user_name, s3_read_policy
├── outputs.tf         # user_arn, policy_arn
├── terraform.tfvars   # s3_read_policy value (git-ignored)
└── readme.md
```