# Project 18: GitOps Deployment with Terraform and GitHub Actions

## Goal
Deploy AWS infrastructure using GitOps: Git is the source of truth, and changes are checked
and applied automatically by a GitHub Actions pipeline.

## Technologies Used
- Terraform (>= 1.5.0, AWS provider v5.100.0)
- AWS S3 (infrastructure and remote state)
- GitHub Actions
- AWS IAM (OIDC role for GitHub Actions)
- Git and GitHub

## Resources
| Resource           | Value |
|--------------------|-------|
| AWS Account        | 590507089733 |
| Region             | us-east-1 |
| State Backend      | `s3://capstone-project18-tfstate-590507089733/project18/terraform.tfstate` |
| State Locking      | S3 lockfile (`use_lockfile = true`), encrypted |
| Managed Resource   | S3 bucket with prefix `capstone-project18-gitops-` |
| Workflow           | [.github/workflows/project18-gitops.yml](../.github/workflows/project18-gitops.yml) |
| Branch / PR        | `project-18-gitops` → `main` (PR #4) |

## Project Structure
```
Project 18/
├── main.tf               # Backend, provider, and S3 bucket resource
├── outputs.tf            # bucket_name output
├── .terraform.lock.hcl   # Pinned provider versions
└── readme.md

.github/workflows/
└── project18-gitops.yml  # GitOps pipeline
```

## Infrastructure
```hcl
resource "aws_s3_bucket" "gitops_bucket" {
  bucket_prefix = "capstone-project18-gitops-"

  tags = {
    Name      = "Project18-GitOps"
    Project   = "Capstone"
    ManagedBy = "Terraform"
  }
}
```

## GitOps Workflow
| Trigger | Paths | Jobs |
|---------|-------|------|
| Pull request to `main` | `Project 18/**`, workflow file | **Validate** (`init -backend=false`, `validate`) |
| Push to `main` | `Project 18/**`, workflow file | **Validate** → **Apply** (`init`, `plan -out=tfplan`, `apply tfplan`) |
| Manual (`workflow_dispatch`) | — | **Validate** → **Apply** |

Security and safety settings:
- **OIDC authentication:** GitHub Actions assumes an AWS role (`vars.AWS_ROLE_ARN`) with `id-token: write`,
  so no AWS access keys are stored in GitHub.
- **Least-privilege token:** `contents: read`.
- **Approval gate:** the Apply job uses the `production` environment.
- **No overlapping deployments:** `concurrency: project18-deployment` with `cancel-in-progress: false`.

## Steps

### 1. Validate locally
```bash
cd "Project 18"
terraform fmt
terraform init -reconfigure
terraform validate
```

### 2. Open a pull request
```bash
git checkout -b project-18-gitops
git add "Project 18" .github/workflows/project18-gitops.yml
git commit -m "Add Project 18 GitOps deployment"
git push origin project-18-gitops
```
Open a pull request to `main`. The pipeline runs **Terraform Validate**.

### 3. Merge to deploy
Merging to `main` runs **Terraform Apply**, which creates the S3 bucket and saves the state in the S3 backend.

## Test Evidence

### 1. Local init and validate
The S3 backend was configured, the AWS provider v5.100.0 was reused from the lock file,
and the configuration is valid.

![Terraform validate](../outputs%20pics/Project%2018/Screenshot%202026-11-21%20123028.png)

### 2. GitHub Actions pipeline
Pull request #4 (`project-18-gitops`) triggered **Project 18 - GitOps Deployment #1** and
**Terraform Validation #19**. Both passed in 17 seconds.

![GitHub Actions](../outputs%20pics/Project%2018/Screenshot%202026-11-21%20123812.png)

### 3. Terraform Apply after merge
[Add a screenshot of the Terraform Apply job on `main` and the `bucket_name` output.]

## Result
Set up a GitOps pipeline for Project 18. Pull requests are validated automatically.
Changes merged to `main` are planned and applied to AWS through GitHub Actions, using OIDC authentication
and remote state in S3 with locking.