# Capstone Project – AWS Infrastructure with Terraform

This repository contains two Terraform projects that build AWS infrastructure as code.

| Project | Description | Main AWS services |
|---------|-------------|-------------------|
| [Project 1](./Project%201) | Web server on EC2 inside a custom VPC | VPC, Subnet, Internet Gateway, Route Table, Security Group, EC2 |
| [Project 2](./Project%202) | Static website hosted on Amazon S3 | S3 (website hosting, bucket policy) |

---

## Prerequisites

- An AWS account with permissions for EC2, VPC and S3
- [Terraform](https://developer.hashicorp.com/terraform/install) version 1.0 or later
- AWS credentials set up locally, for example with `aws configure`
- Git

Check your setup:

```bash
terraform -version
aws sts get-caller-identity
```

---

## Project 1: Web Server on EC2 with a VPC

### Goal
Create a VPC with a public subnet and launch an EC2 instance that runs an Apache web server.

### Architecture

```
                Internet
                    │
          ┌─────────▼─────────┐
          │  Internet Gateway │
          └─────────┬─────────┘
┌───────────────────┼──────────────────────┐
│ VPC 10.0.0.0/16   │                      │
│  ┌────────────────▼───────────────────┐  │
│  │ Public Subnet 10.0.1.0/24          │  │
│  │  ┌──────────────────────────────┐  │  │
│  │  │ EC2 (Amazon Linux 2023)      │  │  │
│  │  │ Apache httpd · t2.micro      │  │  │
│  │  │ Security group: 80, 22       │  │  │
│  │  └──────────────────────────────┘  │  │
│  └────────────────────────────────────┘  │
└──────────────────────────────────────────┘
```

### Resources created

| Resource | Name / Details |
|----------|----------------|
| `aws_vpc` | `project1-vpc` – `10.0.0.0/16`, DNS hostnames enabled |
| `aws_subnet` | `project1-public-subnet` – `10.0.1.0/24`, assigns public IPs automatically |
| `aws_internet_gateway` | `project1-igw` |
| `aws_route_table` | `project1-route-table` – route `0.0.0.0/0` to the Internet Gateway |
| `aws_route_table_association` | Links the public subnet to the route table |
| `aws_security_group` | `project1-web-sg` – inbound HTTP (80) and SSH (22), all outbound traffic allowed |
| `aws_instance` | `project1-webserver` – latest Amazon Linux 2023 AMI; user data installs Apache and publishes a test page |

### Variables

| Name | Default | Description |
|------|---------|-------------|
| `aws_region` | `us-east-1` | AWS region |
| `instance_type` | `t2.micro` | EC2 instance type (note: `main.tf` currently hardcodes `t2.micro`) |

### Outputs

| Name | Description |
|------|-------------|
| `public_ip` | Public IP of the web server |
| `public_dns` | Public DNS name of the web server |

### Deploy

```bash
cd "Project 1"
terraform init
terraform plan
terraform apply
```

Open `http://<public_ip>` in a browser. Apache can take 1–2 minutes to finish installing after the instance starts.

### Screenshots

![Project 1 - 1](./outputs%20pics/Project%201/Screenshot%202026-11-19%20210027.png)
![Project 1 - 2](./outputs%20pics/Project%201/Screenshot%202026-11-19%20210145.png)
![Project 1 - 3](./outputs%20pics/Project%201/Screenshot%202026-11-19%20210803.png)
![Project 1 - 4](./outputs%20pics/Project%201/Screenshot%202026-11-19%20211315.png)
![Project 1 - 5](./outputs%20pics/Project%201/Screenshot%202026-11-19%20211341.png)

### Clean up

```bash
terraform destroy
```

---

## Project 2: Host a Static Website on Amazon S3

### Goal
Publish a simple static website using Amazon S3.

### Tasks completed
- Created an S3 bucket with static website hosting turned on
- Uploaded `index.html`
- Made the site public using a bucket policy

### Architecture

```
  Browser ──HTTP──► S3 website endpoint
                    (<bucket>.s3-website-<region>.amazonaws.com)
                              │
                    ┌─────────▼──────────┐
                    │ S3 Bucket          │
                    │  index.html        │
                    │  Public read policy│
                    └────────────────────┘
```

### Resources created

| Resource | Purpose |
|----------|---------|
| `aws_s3_bucket` | The website bucket (name comes from `var.bucket_name`) |
| `aws_s3_bucket_public_access_block` | Turns off Block Public Access so a public policy is allowed |
| `aws_s3_bucket_website_configuration` | Turns on website hosting with `index.html` as the index document |
| `aws_s3_object` | Uploads `index.html` with `Content-Type: text/html` |
| `aws_s3_bucket_policy` | Lets anyone run `s3:GetObject` on objects in the bucket |

### Variables

| Name | Default | Description |
|------|---------|-------------|
| `aws_region` | `us-east-1` | AWS region |
| `bucket_name` | *(required)* | S3 bucket name. It must be unique across all of AWS and use only lowercase letters, numbers and hyphens |

Set the bucket name in `terraform.tfvars`. This file is listed in `.gitignore`, so it isn't committed.

```hcl
bucket_name = "capstone-project2-<yourname>-<random>"
```

### Outputs

| Name | Description |
|------|-------------|
| `website_url` | S3 website endpoint |
| `bucket_name` | Name of the bucket that was created |

### Deploy

```bash
cd "Project 2"
terraform init
terraform plan
terraform apply
```

Open `http://<website_url>` in a browser. S3 website endpoints only support HTTP, not HTTPS.

To change the site, edit `index.html` and run `terraform apply` again.

### Screenshots

![Project 2 - 1](./outputs%20pics/Project%202/Screenshot%202026-11-19%20214136.png)
![Project 2 - 2](./outputs%20pics/Project%202/Screenshot%202026-11-19%20215311.png)
![Project 2 - 3](./outputs%20pics/Project%202/Screenshot%202026-11-19%20215617.png)

### Clean up

```bash
terraform destroy
```

---

## Repository Structure

```
Capstone/
├── Project 1/
│   ├── main.tf          # VPC, networking, security group, EC2
│   ├── variables.tf     # Input variables
│   └── outputs.tf       # public_ip, public_dns
├── Project 2/
│   ├── main.tf          # S3 bucket, website config, policy, object upload
│   ├── variables.tf     # Input variables
│   ├── output.tf        # website_url, bucket_name
│   └── index.html       # Website content
├── outputs pics/        # Deployment screenshots for both projects
├── .gitignore           # Ignores .terraform/, *.tfstate, *.tfvars
└── readme.md
```

---

## Troubleshooting

| Problem | Likely cause / fix |
|---------|--------------------|
| Project 1 page doesn't load | Wait 1–2 minutes for user data to finish. Make sure you use `http://`, not `https://`. Check that the security group allows port 80 |
| `BucketAlreadyExists` | Bucket names are unique across all of AWS. Choose a different `bucket_name` |
| `AccessDenied` when applying the bucket policy | Block Public Access is still on at the account level. Turn it off in S3 → *Block Public Access settings for this account* |
| Website returns `403 Forbidden` | The bucket policy is missing or wrong, or Block Public Access is on |
| Website returns `404 NoSuchKey` | `index.html` wasn't uploaded. Run `terraform apply` from inside the `Project 2` folder |
| Browser downloads the file instead of showing it | `content_type` must be `text/html` |
| Credential errors | Run `aws configure` and check with `aws sts get-caller-identity` |

---

## Security Notes

- **Project 1** allows SSH (port 22) from `0.0.0.0/0`. Outside a demo, limit it to your own IP or use AWS Systems Manager Session Manager.
- **Project 2** makes every object in the bucket publicly readable. Put only public content in this bucket.
- Never commit `terraform.tfstate`, `*.tfvars` or AWS credentials. This repository's `.gitignore` already excludes state and tfvars files.

---

## Best Practices Used / Recommended

- Run `terraform fmt` and `terraform validate` before you commit.
- Always review `terraform plan` before running `apply`.
- For team use, store state remotely (S3 backend with state locking).
- Tag every resource with project and environment names.
- Run `terraform destroy` when you finish so you don't keep paying for resources.

---

## Cost

Both projects use small resources (a t2.micro instance and a tiny S3 bucket). Charges depend on your account's AWS Free Tier eligibility and how much you use them. Run `terraform destroy` when you're done.

---

## Possible Enhancements

- **Project 1:** Elastic IP, Application Load Balancer, Auto Scaling Group, CloudWatch alarms
- **Project 2:** CloudFront with HTTPS (ACM), a custom domain with Route 53, an `error.html` page, CI/CD with GitHub Actions

---

## References

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Amazon S3 static website hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [Amazon EC2 documentation](https://docs.aws.amazon.com/ec2/)