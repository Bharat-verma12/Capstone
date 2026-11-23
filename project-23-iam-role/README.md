# Project 23: IAM Role-Based Access

## Goal
Secure AWS resource access using an IAM role.

## AWS Services
- AWS IAM
- Amazon EC2
- Amazon S3
- AWS CLI

## Resources
| Resource          | Value |
|-------------------|-------|
| AWS Account       | 590507089733 |
| Region            | us-east-1 |
| IAM Role          | EC2-S3-Access-Role |
| Instance Profile  | EC2-S3-Instance-Profile (`AIPAYS7HXD5CWFZGZVX43`) |
| EC2 Instance      | i-06ad9757a3d3f9f67 |
| Association ID    | iip-assoc-035358f976f12dd75 |
| S3 Bucket         | bharat-project23-iam-590507089733 |

## Trust Policy
The [trust-policy.json](./trust-policy.json) file lets the EC2 service assume the role:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "ec2.amazonaws.com" },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

## Implementation
1. Created `EC2-S3-Access-Role` with the EC2 trust policy.
2. Attached the S3 policies to the role.
3. Created `EC2-S3-Instance-Profile` and added the role to it.
4. Associated the instance profile with the EC2 instance.
5. Created an S3 bucket, uploaded a test file, and listed the bucket contents.

## Commands Used
```bash
# Check the policies attached to the role
aws iam list-attached-role-policies --role-name EC2-S3-Access-Role

# Associate the instance profile with EC2
aws ec2 associate-iam-instance-profile \
  --instance-id i-06ad9757a3d3f9f67 \
  --iam-instance-profile Name=EC2-S3-Instance-Profile \
  --region us-east-1

# Check the association
aws ec2 describe-iam-instance-profile-associations \
  --region us-east-1 \
  --filters Name=instance-id,Values=i-06ad9757a3d3f9f67 \
  --output table

# S3 test
aws s3 mb s3://bharat-project23-iam-590507089733 --region us-east-1
echo "Project 23 IAM Role Based Access" > test.txt
aws s3 cp test.txt s3://bharat-project23-iam-590507089733/
aws s3 ls s3://bharat-project23-iam-590507089733/

# Run on the EC2 instance to confirm it uses the role
aws sts get-caller-identity
aws s3 ls s3://bharat-project23-iam-590507089733/
```

## Test Evidence

### 1. Console role creation blocked
Creating the role in the IAM console failed at the **Add permissions** step with
`Access denied to iam:ListPolicies`, because no identity-based policy allowed that action.
The role setup was finished with the AWS CLI instead.

![Access denied in console](../outputs%20pics/Project%2023/Screenshot%202026-11-22%20004446.png)

### 2. Policies attached to the role
`EC2-S3-Access-Role` has `AmazonS3ReadOnlyAccess` and `AmazonS3FullAccess` attached.

![Attached role policies](../outputs%20pics/Project%2023/Screenshot%202026-11-22%20004746.png)

### 3. Instance profile associated with EC2
There was no association at first. `associate-iam-instance-profile` then linked
`EC2-S3-Instance-Profile` to `i-06ad9757a3d3f9f67`, with state `associating`.

![Associate instance profile](../outputs%20pics/Project%2023/Screenshot%202026-11-22%20005124.png)

### 4. Association confirmed
The association `iip-assoc-035358f976f12dd75` shows the state `associated`.

![Association confirmed](../outputs%20pics/Project%2023/Screenshot%202026-11-22%20005147.png)

### 5. S3 bucket and object test
Created the bucket, uploaded `test.txt` (33 bytes), and listed it
(`2026-11-21 19:28:42`).

![S3 test](../outputs%20pics/Project%2023/Screenshot%202026-11-22%20005901.png)

### 6. Role used from EC2
[Add a screenshot of `aws sts get-caller-identity` run on the EC2 instance. The ARN should contain `assumed-role/EC2-S3-Access-Role`.]

## Challenges
- **Console access denied:** the IAM user did not have the `iam:ListPolicies` permission,
  so the role could not be finished in the console. The AWS CLI was used instead.
- **Policy scope:** `AmazonS3FullAccess` is attached as well as `AmazonS3ReadOnlyAccess`.
  To follow least privilege, the role should keep only `AmazonS3ReadOnlyAccess`.

## Deliverables
- IAM role and trust policy ([trust-policy.json](./trust-policy.json))
- EC2 instance profile association
- S3 CLI test output ([test.txt](./test.txt))
- Screenshots ([outputs pics/Project 23](../outputs%20pics/Project%2023/))

## Result
`EC2-S3-Access-Role` was created with an EC2 trust policy and S3 permissions,
added to `EC2-S3-Instance-Profile`, and associated with instance `i-06ad9757a3d3f9f67`
(state: `associated`). With this setup, the instance gets temporary credentials
from the role instead of needing static AWS access keys.
