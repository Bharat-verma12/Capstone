# Project 7: CI Validation for Terraform using GitHub Actions

[![Terraform Validation](https://github.com/Bharat-verma12/Capstone/actions/workflows/terraform.yml/badge.svg?branch=main)](https://github.com/Bharat-verma12/Capstone/actions/workflows/terraform.yml)

## Objective

Set up a Continuous Integration (CI) pipeline with GitHub Actions. It checks Terraform formatting and validates the configuration on every push and pull request.

## Tools Used

| Tool | Purpose |
|------|---------|
| Git & GitHub | Version control and code hosting |
| GitHub Actions | CI pipeline execution |
| Terraform | Infrastructure as Code |
| `hashicorp/setup-terraform@v3` | Installs Terraform on the runner |
| Windows runner (`windows-latest`) | Runs the pipeline steps in PowerShell |

## Workflow File

Location: [`.github/workflows/terraform.yml`](../.github/workflows/terraform.yml)

```yaml
name: Terraform Validation

on:
  push:
    branches:
      - main
      - feature/update-terraform
  pull_request:

jobs:
  terraform:
    runs-on: windows-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Terraform Init
        shell: pwsh
        run: terraform init

      - name: Terraform Format Check
        shell: pwsh
        run: terraform fmt -check

      - name: Terraform Validate
        shell: pwsh
        run: terraform validate
```

## Pipeline Stages

1. **Checkout Repository**: pulls the source code onto the runner.
2. **Setup Terraform**: installs the Terraform CLI.
3. **Terraform Init**: sets up the working directory and providers.
4. **Terraform Format Check**: fails if any `.tf` file is not formatted correctly.
5. **Terraform Validate**: checks the configuration syntax and its internal consistency.

## Implementation Steps

### Step 1: Verify branches and remote

```powershell
git branch -vv
git remote -v
```

![Branch and remote check](../outputs%20pics/Project%207/Screenshot%202026-11-20%20104654.png)

- `feature/update-terraform` tracks `origin/feature/update-terraform`.
- `main` uses the Windows GitHub runner configuration.
- Remote `origin` points to `https://github.com/Bharat-verma12/Capstone.git`.

### Step 2: Trigger the workflow

```powershell
echo trigger >> trigger.txt
git add trigger.txt
git commit -m "Trigger workflow"
git push origin feature/update-terraform
```

![Triggering the workflow](../outputs%20pics/Project%207/Screenshot%202026-11-20%20104427.png)

The push created the `feature/update-terraform` branch on GitHub. GitHub also suggested opening a pull request.

### Step 3: Verify the pipeline run

Open **GitHub → Actions → Terraform Validation**.

![Successful workflow run](../outputs%20pics/Project%207/Screenshot%202026-11-20%20105729.png)

- Workflow: **Terraform Validation #3**
- Branch: `main` (commit `1fbf10d`)
- Status: ✅ **Success**
- Duration: **16s**

## Result

The CI pipeline runs automatically on pushes to `main` and `feature/update-terraform` and on every pull request. Terraform code is checked for formatting and validity before it is merged.

## Note

The workflow runs from the repository root. To validate a specific Terraform project, add a `working-directory` to the job:

```yaml
jobs:
  terraform:
    runs-on: windows-latest
    defaults:
      run:
        working-directory: ./<terraform-project-folder>
```

## Links

- [GitHub Actions runs](https://github.com/Bharat-verma12/Capstone/actions/workflows/terraform.yml)