# Cloud & DevOps Capstone

**Author:** Bharat Verma · **Repository:** [Bharat-verma12/Capstone](https://github.com/Bharat-verma12/Capstone)

A set of hands-on projects covering AWS infrastructure, Infrastructure as Code (Terraform), CI/CD and GitOps
(GitHub Actions), containers (Docker, ECR, EKS), configuration management (Ansible), monitoring and logging
(CloudWatch), identity (IAM, Active Directory), and reliability (backups, lifecycle policies, chaos testing).

Each project has its own folder and README with steps, commands, and screenshots.

---

## Tech Stack

| Area | Tools |
|------|-------|
| Cloud | AWS: EC2, VPC, S3, IAM, CloudWatch, ALB, ACM, ECR, EKS |
| Infrastructure as Code | Terraform (AWS provider v5/v6), `terraform-aws-modules/eks` |
| CI/CD | GitHub Actions (`windows-latest`), OIDC authentication to AWS |
| Linux administration | useradd, groupadd, usermod, chown, chmod |
| Containers | Docker, Nginx, Amazon ECR, Amazon EKS, kubectl |
| Configuration management | Ansible |
| Windows infrastructure | Active Directory Domain Services, Windows DNS |
| Scripting | Bash, PowerShell, cron |

---

## Project Index

| # | Project | Area | Key Tools | Folder |
|---|---------|------|-----------|--------|
| 1 | Web server on EC2 in a custom VPC | IaC / Networking | Terraform, VPC, EC2, Apache | [Project 1](./Project%201/readme.md) |
| 2 | Static website on S3 | IaC / Storage | Terraform, S3 | [Project 2](./Project%202/readme.md) |
| 3 | EC2 monitoring with a CloudWatch CPU alarm | IaC / Monitoring | Terraform, CloudWatch | [Project 3](./Project%203/readme.md) |
| 4 | IAM user automation | IaC / Security | Terraform, IAM | [Project 4](./Project%204/readme.md) |
| 5 | Linux users, groups, and permissions | Linux / Security | useradd, groupadd, chown, chmod | [Project 5](./Project%205/readme.md) |
| 6 | Terraform and GitHub workflow (feature branches) | Version control | Git, GitHub | [Project 6](./Project%206/readme.md) |
| 7 | CI validation for Terraform | CI/CD | GitHub Actions | [project 7](./project%207/readme.md) |
| 8 | Build and run a Docker app locally | Containers | Docker, Nginx | [project-8-docker-app](./project-8-docker-app/README.md) |
| 9 | Domain controller setup | Identity | AD DS | [Project 9](./Project%209/readme.md) |
| 10 | Internal DNS setup | Networking | Windows DNS | [Project 10](./Project%2010/readme.md) |
| 11 | EC2 instance with resource tagging | IaC | Terraform | [Project 11](./Project%2011/README.md) |
| 12 | Terraform plan CI pipeline | CI/CD | GitHub Actions | [Project 12](./Project%2012/readme.md) |
| 13 | Build a Docker image and push it to ECR | Containers | Docker, ECR | [Project 13](./Project%2013/readme.md) |
| 14 | App deployment on EKS | Kubernetes | Terraform, EKS, kubectl | [project14](./project14/README.md) |
| 15 | Nginx setup with Ansible | Config management | Ansible, Nginx | [Project15](./Project15/readme.md) |
| 16 | HTTPS with ACM | Security / Networking | ACM, ALB | [Project 16](./Project%2016/README.md) |
| 17 | Log forwarding to CloudWatch | Logging | CloudWatch Agent | [Project 17](./Project%2017/README.md) |
| 18 | GitOps deployment | GitOps | Terraform, GitHub Actions, OIDC | [Project 18](./Project%2018/readme.md) |
| 19 | Scheduled S3 backup | Automation / DR | Bash, cron, S3 | [Project19](./Project19/README.md) |
| 20 | Load-balanced app deployment | High availability | EC2, ALB | [project-20-load-balancer](./project-20-load-balancer/README.md) |
| 21 | CloudWatch monitoring dashboard | Monitoring | CloudWatch | [project-21-cloudwatch-dashboard](./project-21-cloudwatch-dashboard/README.md) |
| 22 | S3 log archive with lifecycle rules | Cost optimization | S3 Lifecycle, Glacier | [Project 22](./Project%2022/README.md) |
| 23 | IAM role-based access | Security | IAM Role, Instance Profile | [project-23-iam-role](./project-23-iam-role/README.md) |
| 24 | Manual chaos test | Reliability | systemctl, curl | [project-24-manual-chaos-test](./project-24-manual-chaos-test/readme.md) |


---

## Project Summaries

### Infrastructure as Code (Terraform)
- **Project 1:** Custom VPC (`10.0.0.0/16`), public subnet, internet gateway, route table, and security group.
  An Amazon Linux 2023 EC2 instance installs Apache through user data.
- **Project 2:** S3 bucket with static website hosting, a public-read bucket policy, and an uploaded `index.html`.
- **Project 3:** EC2 instance plus the `HighCPUAlarm` CloudWatch alarm (average CPU above 70% for 2 periods of 120 seconds).
- **Project 4:** IAM user `s3-readonly-user` with an S3 read-only policy. The policy JSON is passed in as a variable.
- **Project 11:** Single EC2 instance with `Name`, `Environment`, and `Owner` tags.

### Linux Administration
- **Project 5:** Users `alice` and `bob` and the group `developers`, with `alice` added to the group.
  The directory `/secure-data` is owned by `root:developers` with mode `770`, so the owner and group have full access and others have none.

### CI/CD and GitOps
- **Project 6:** Feature-branch workflow (`feature/update-terraform`) and pushes to GitHub.
- **Project 7:** [`terraform.yml`](./.github/workflows/terraform.yml) runs `init`, `fmt -check`, and `validate` on pushes and pull requests.
- **Project 12:** [`terraform-plan.yml`](./.github/workflows/terraform-plan.yml) runs `init`, `validate`, and `plan` on pushes to `main`, and uploads `tfplan` as an artifact.
- **Project 18:** [`project18-gitops.yml`](./.github/workflows/project18-gitops.yml) validates pull requests and applies changes on merge to `main`.
  It uses OIDC to assume an AWS role (no stored keys), a `production` environment approval gate,
  and S3 remote state with lockfile-based locking.

### Containers and Kubernetes
- **Project 8:** `nginx:alpine` image `project8-app:v1`, run with port mapping `8080:80`.
- **Project 13:** Image built from `nginx:latest`, tagged, and pushed to a private ECR repository `myapp` (us-east-1).
- **Project 14:** EKS cluster `project14-eks` (ap-south-1, 2× t3.medium nodes) created with Terraform.
  A 2-replica Nginx app is exposed through a `LoadBalancer` service.

### Windows Infrastructure
- **Project 9:** AD DS domain controller with two domain users.
- **Project 10:** AD-integrated DNS zone `capstone.local` with the A record `webserver.capstone.local → 10.5.3.130`.

### Configuration Management
- **Project 15:** Ansible playbook that installs, starts, and enables Nginx and deploys a custom homepage (`ok=5 changed=3 failed=0`).

### Networking, Security, and High Availability
- **Project 16:** ACM certificate on an ALB HTTPS listener (443). HTTP is redirected (301) or blocked.
  Only the ALB can reach the EC2 instances.
- **Project 20:** Two EC2 instances running Nginx, registered in `project20-target-group` behind `project20-alb`.
- **Project 23:** Role `EC2-S3-Access-Role` and instance profile attached to EC2, so the instance uses
  temporary credentials instead of access keys.

### Monitoring and Logging
- **Project 17:** CloudWatch agent forwards system and Nginx logs to `project17-system-logs` and `project17-nginx-logs` (7-day retention).
- **Project 21:** `Project21-EC2-Monitoring` dashboard with CPU, NetworkIn, NetworkOut, and StatusCheckFailed widgets.

### Backup, Cost, and Reliability
- **Project 19:** `backup.sh` creates a timestamped `.tar.gz` and uploads it to S3. Cron runs it daily at 02:00 UTC.
- **Project 22:** Lifecycle rule `Archive-Old-Logs` moves objects under `logs/` to Glacier after 30 days and deletes them after 365 days.
- **Project 24:** Nginx stopped deliberately. The outage was detected with systemctl and curl, and the service was restarted.

---

## Repository Structure

```
Capstone/
├── .github/workflows/
│   ├── terraform.yml            # Project 7: fmt and validate
│   ├── terraform-plan.yml       # Project 12: plan and artifact
│   └── project18-gitops.yml     # Project 18: GitOps validate and apply
├── Project 1 … Project 24/      # One folder per project (*.tf, scripts, configs, README)
├── outputs pics/Project N/      # Screenshot evidence for each project
├── .gitignore                   # Ignores .terraform/, *.tfstate, *.tfvars, crash logs
└── readme.md                    # This file
```

---

## Prerequisites

- An AWS account and the AWS CLI v2 configured (`aws configure` or SSO)
- Terraform 1.5 or later
- Docker, kubectl, and Ansible (for projects 8, 13, 14, and 15)
- An Ubuntu Linux VM (for projects 8, 13, 15, 19, and 24)
- Windows Server (for projects 9 and 10)

## General Terraform Usage

Each Terraform project is self-contained. Run commands from inside its folder:

```powershell
cd "Project 1"
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
terraform destroy   # clean up when finished
```



---

## Security Practices

- State files, `.tfvars`, and `.terraform/` are excluded by `.gitignore`. Never commit credentials.
- Project 18 authenticates GitHub Actions to AWS with OIDC, not long-lived access keys.
- Project 23 gives EC2 access to S3 through an IAM role, not access keys on the instance.
- Several demo projects open SSH to `0.0.0.0/0` or use broad policies (`Resource: "*"`, `AmazonS3FullAccess`).
  Restrict these before any non-demo use.



## Cleanup

Destroy cloud resources after each project to avoid charges: `terraform destroy`, `kubectl delete -f`,
`aws s3 rb --force`, and so on. Each project README has its own cleanup steps.

---

*Created for educational purposes as part of a Cloud & DevOps capstone.*