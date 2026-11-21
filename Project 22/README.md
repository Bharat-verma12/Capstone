
# Project 22: S3 Log Archive with Lifecycle

## Goal
Reduce AWS storage costs using S3 Lifecycle policies.

## Technologies
- AWS S3
- AWS CLI
- Linux VM
- Git and GitHub

## Implementation
1. Created an S3 bucket in us-east-1.
2. Generated sample application logs.
3. Uploaded log files to Amazon S3.
4. Created an S3 Lifecycle configuration.
5. Configured Glacier Flexible Retrieval transition
   after 30 days.
6. Configured object expiration after 365 days.
7. Verified the lifecycle rule using AWS CLI
   and AWS Management Console.

## Verification
aws s3api get-bucket-lifecycle-configuration \
  --bucket <bucket-name>

## Deliverable
S3 Lifecycle rule screenshot.

## Notes
S3 Lifecycle actions run asynchronously.
Objects smaller than 128 KB do not transition
to Glacier by default.

## Outcome
Configured automated lifecycle management
for archived application logs.
