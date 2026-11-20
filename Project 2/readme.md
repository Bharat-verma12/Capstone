# Project 2: Host a Static Website on Amazon S3 using Terraform

## Goal
Publish a simple static website using Amazon S3.

## Tasks
- [x] Create a bucket with website hosting turned on
- [x] Upload `index.html`
- [x] Make the site public

## Architecture

```
  Browser ──HTTP──►  S3 Website Endpoint
                     bharat-verma-static-site-2026.s3-website-us-east-1.amazonaws.com
                                  │
                    ┌─────────────▼──────────────┐
                    │ S3 Bucket                  │
                    │  • Website hosting enabled │
                    │  • index.html (text/html)  │
                    │  • Public read policy      │
                    │  • Block Public Access off │
                    └────────────────────────────┘
```

## Resources Created

| Resource | Purpose |
|----------|---------|
| `aws_s3_bucket.website_bucket` | S3 bucket that holds the website (name comes from `var.bucket_name`) |
| `aws_s3_bucket_public_access_block.public_access` | Turns off the four Block Public Access settings so a public bucket policy is allowed |
| `aws_s3_bucket_website_configuration.website` | Turns on static website hosting with `index.html` as the index document |
| `aws_s3_object.index` | Uploads `index.html` with `Content-Type: text/html` |
| `aws_s3_bucket_policy.public_policy` | Lets everyone (`Principal: *`) run `s3:GetObject` on all objects. Depends on the public access block |

### Bucket policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::<bucket_name>/*"
    }
  ]
}
```

## Variables

| Name | Default | Description |
|------|---------|-------------|
| `aws_region` | `us-east-1` | AWS region |
| `bucket_name` | *(required)* | S3 bucket name. It must be unique across all of AWS and use only lowercase letters, numbers and hyphens |

Set the bucket name in `terraform.tfvars`:

```hcl
bucket_name = "bharat-verma-static-site-2026"
```

## Outputs

| Name | Description |
|------|-------------|
| `website_url` | S3 static website endpoint |
| `bucket_name` | Name of the bucket that was created |

## Website Content (`index.html`)

```html
<!DOCTYPE html>
<html>
<head>
    <title>My Static Website</title>
</head>
<body>
    <h1>Hello from Amazon S3!</h1>
    <p>Hosted using Terraform</p>
</body>
</html>
```

## Prerequisites
- Terraform
- AWS CLI set up with credentials that can manage S3
- Your account's S3 **Block Public Access** settings must allow public bucket policies

## Deploy

```powershell
cd "Project 2"
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

## Access the Website

```powershell
terraform output website_url
```

Open `http://<website_url>` in a browser. S3 website endpoints support **HTTP only**, not HTTPS.

## Updating the Website

Edit `index.html`, then run:

```powershell
terraform apply -replace="aws_s3_object.index"
```

The `aws_s3_object` resource has no `etag`, so Terraform doesn't notice when only the file's content changes. To have changes picked up automatically, add `etag = filemd5("index.html")` to the resource.

## Screenshots

![Project 2 - 1](../outputs%20pics/Project%202/Screenshot%202026-11-19%20214136.png)
![Project 2 - 2](../outputs%20pics/Project%202/Screenshot%202026-11-19%20215311.png)
![Project 2 - 3](../outputs%20pics/Project%202/Screenshot%202026-11-19%20215617.png)

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `BucketAlreadyExists` / `BucketAlreadyOwnedByYou` | Bucket names are unique across all of AWS. Choose a different `bucket_name` |
| `AccessDenied` when applying the bucket policy | Account-level Block Public Access is on. Turn it off in S3 → *Block Public Access settings for this account* |
| `403 Forbidden` in browser | The bucket policy is missing, or Block Public Access is still on |
| `404 NoSuchKey` | `index.html` wasn't uploaded. Run Terraform from inside the `Project 2` folder |
| Browser downloads the file instead of showing it | `content_type` must be `text/html` |
| Changes to `index.html` don't show up | See [Updating the Website](#updating-the-website) |
| Site won't load over `https://` | S3 website endpoints only support HTTP. Use CloudFront for HTTPS |

## Clean Up

```powershell
terraform destroy
```

Terraform deletes `index.html` and then the bucket. If you added other objects by hand, delete them first, or set `force_destroy = true` on the bucket.

## Security Notes
- Anyone on the internet can read every object in this bucket. Put only public content in it.
- Don't commit `terraform.tfstate`, `*.tfvars` or `tfplan` files.

## Possible Enhancements
- CloudFront with HTTPS through ACM, using Origin Access Control so the bucket stays private
- Custom domain with Route 53
- `error.html` page through `error_document`
- `etag = filemd5(...)` so content changes upload automatically
- A `terraform { required_providers { ... } }` block to pin the AWS provider version
- CI/CD with GitHub Actions

## File Structure

```
Project 2/
├── main.tf            # Provider, S3 bucket, public access block, website config, object, policy
├── variables.tf       # aws_region, bucket_name
├── output.tf          # website_url, bucket_name
├── index.html         # Website content
├── terraform.tfvars   # bucket_name value (git-ignored)
└── readme.md
```