# Project 1: Deploy a Web Server on EC2 in a Custom VPC using Terraform

## Goal
Use Terraform to build a custom VPC with public networking and launch an EC2 instance that serves a web page with Apache.

## Tasks
- [x] Create a VPC and a public subnet
- [x] Add an Internet Gateway and a route table for internet access
- [x] Create a security group that allows HTTP and SSH
- [x] Launch an EC2 instance that installs Apache with user data
- [x] Open the web page with the instance's public IP

## Architecture

```
                     Internet
                         │
               ┌─────────▼─────────┐
               │ Internet Gateway  │  project1-igw
               └─────────┬─────────┘
┌────────────────────────┼─────────────────────────────┐
│ VPC 10.0.0.0/16        │              project1-vpc   │
│        ┌───────────────▼───────────────┐             │
│        │ Route Table: 0.0.0.0/0 → IGW  │             │
│        └───────────────┬───────────────┘             │
│  ┌─────────────────────▼──────────────────────────┐  │
│  │ Public Subnet 10.0.1.0/24                      │  │
│  │   ┌──────────────────────────────────────────┐ │  │
│  │   │ EC2: project1-webserver                  │ │  │
│  │   │ Amazon Linux 2023 · t2.micro · Apache    │ │  │
│  │   │ SG: project1-web-sg (80, 22 inbound)     │ │  │
│  │   └──────────────────────────────────────────┘ │  │
│  └────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────┘
```

## Resources Created

| Resource | Name | Details |
|----------|------|---------|
| `aws_vpc.main` | `project1-vpc` | CIDR `10.0.0.0/16`, DNS hostnames enabled |
| `aws_subnet.public` | `project1-public-subnet` | CIDR `10.0.1.0/24`, assigns public IPs automatically |
| `aws_internet_gateway.gw` | `project1-igw` | Attached to the VPC |
| `aws_route_table.public` | `project1-route-table` | Route `0.0.0.0/0` → Internet Gateway |
| `aws_route_table_association.public` | – | Links the public subnet to the route table |
| `aws_security_group.web_sg` | `project1-web-sg` | Inbound HTTP (80) and SSH (22) from `0.0.0.0/0`; all outbound traffic allowed |
| `aws_instance.web` | `project1-webserver` | Latest Amazon Linux 2023 AMI, `t2.micro`, public IP, user data |
| `data.aws_ami.amazon_linux` | – | Looks up the latest `al2023-ami-*-x86_64` image owned by Amazon |

## User Data

When the instance first starts, it runs this script:

```bash
#!/bin/bash
dnf update -y
dnf install -y httpd
systemctl enable httpd
systemctl start httpd

cat > /var/www/html/index.html <<HTML
<h1>Hello This is the capstone Project</h1>
<p>Project 1 Completed Successfully</p>
HTML
```

## Provider

- Terraform version 1.0 or later
- AWS provider `~> 6.0`

## Variables

| Name | Default | Description |
|------|---------|-------------|
| `aws_region` | `us-east-1` | AWS region |
| `instance_type` | `t2.micro` | EC2 instance type. **Note:** `main.tf` currently hardcodes `t2.micro`, so changing this variable has no effect |

## Outputs

| Name | Description |
|------|-------------|
| `public_ip` | Public IP address of the web server |
| `public_dns` | Public DNS name of the web server |

## Prerequisites
- Terraform
- AWS CLI set up with credentials that can manage VPC and EC2

## Deploy

```powershell
cd "Project 1"
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

## Access the Website

```powershell
terraform output public_ip
```

Open `http://<public_ip>` in a browser. Apache can take **1–2 minutes** to finish installing after the instance starts. You should see:

> **Hello This is the capstone Project**
> Project 1 Completed Successfully

## Screenshots

![Project 1 - 1](../outputs%20pics/Project%201/Screenshot%202026-11-19%20210027.png)
![Project 1 - 2](../outputs%20pics/Project%201/Screenshot%202026-11-19%20210145.png)
![Project 1 - 3](../outputs%20pics/Project%201/Screenshot%202026-11-19%20210803.png)
![Project 1 - 4](../outputs%20pics/Project%201/Screenshot%202026-11-19%20211315.png)
![Project 1 - 5](../outputs%20pics/Project%201/Screenshot%202026-11-19%20211341.png)

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Page doesn't load | Wait 1–2 minutes for user data to finish. Use `http://`, not `https://` |
| Connection timed out | Check that the security group allows port 80 and the route table sends traffic to the IGW |
| Default Apache test page appears | User data hasn't finished, or it failed. Check `/var/log/cloud-init-output.log` on the instance |
| Can't SSH | The instance has no `key_name`. Use EC2 Instance Connect, or add a key pair |
| `terraform output` shows nothing | Run it from inside the `Project 1` folder |

## Clean Up

```powershell
terraform destroy
```

## Security Notes
- SSH (port 22) is open to `0.0.0.0/0`. Outside a demo, limit it to your own IP or use SSM Session Manager.
- The site uses HTTP only.
- Don't commit `terraform.tfstate`, `*.tfvars` or `tfplan` files.

## Possible Enhancements
- Use `var.instance_type` in `main.tf` instead of the hardcoded value
- Elastic IP for a fixed address
- Application Load Balancer and Auto Scaling Group across multiple subnets and availability zones
- HTTPS with ACM on an ALB
- CloudWatch monitoring and alarms
- Restrict SSH, or remove it and use SSM

## File Structure

```
Project 1/
├── main.tf         # Provider, AMI lookup, VPC, subnet, IGW, route table, SG, EC2
├── variables.tf    # aws_region, instance_type
├── outputs.tf      # public_ip, public_dns
└── readme.md
```