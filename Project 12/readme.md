# Project 12: Terraform Plan CI Pipeline with GitHub Actions

## Goal
Run Terraform automatically on every push to `main`, so that infrastructure changes are checked and
planned in CI before anyone applies them.

## Technologies Used
- Terraform
- GitHub Actions (`windows-latest` runner, PowerShell 7)
- `hashicorp/setup-terraform@v3`
- `actions/checkout@v4`
- `actions/upload-artifact@v4`
- Git and GitHub

## Workflow
| Item       | Value |
|------------|-------|
| File       | [.github/workflows/terraform-plan.yml](../.github/workflows/terraform-plan.yml) |
| Name       | Terraform Plan |
| Trigger    | `push` to `main` |
| Runner     | `windows-latest` (runner version 2.338.2) |
| Artifact   | `terraform-plan` (the `tfplan` file) |

```yaml
name: Terraform Plan

on:
  push:
    branches:
      - main

jobs:
  terraform:
    runs-on: windows-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Terraform Init
        run: terraform init

      - name: Terraform Validate
        run: terraform validate

      - name: Terraform Plan
        run: terraform plan -out=tfplan

      - name: Upload Terraform Plan
        uses: actions/upload-artifact@v4
        with:
          name: terraform-plan
          path: tfplan
```

## Pipeline Steps
| Step | Purpose | Duration |
|------|---------|----------|
| Set up job | Prepare the runner and download actions | 1s |
| Checkout Code | Clone the repository | 8s |
| Setup Terraform | Install the Terraform CLI | 2s |
| Terraform Init | Download providers and initialize | 0s |
| Terraform Validate | Check the configuration syntax | 1s |
| Terraform Plan | Create the execution plan (`tfplan`) | 1s |
| Upload Terraform Plan | Save `tfplan` as a build artifact | 0s |
| Post Checkout Code | Clean up | 3s |

## Test Evidence

### 1. Workflow runs
The **Terraform Plan** workflow has 2 runs on `main`:
- **#1 "pic update"** (commit `badf00d`): ❌ failed (20s)
- **#2 "update the .tf"** (commit `16eb007`): ✅ succeeded (23s)

![Workflow runs](../outputs%20pics/Project%2012/Screenshot%202026-11-20%20211625.png)

### 2. Successful run: all steps passed
Run #2 finished the `terraform` job in 19s, with 2 warning annotations.

![Job steps](../outputs%20pics/Project%2012/Screenshot%202026-11-20%20211354.png)

### 3. Job setup
The runner downloaded `actions/checkout@v4`, `hashicorp/setup-terraform@v3`, and `actions/upload-artifact@v4`.

![Set up job](../outputs%20pics/Project%2012/Screenshot%202026-11-20%20211649.png)

### 4. Terraform Plan step
`terraform plan -out=tfplan` ran in PowerShell 7 (`pwsh.EXE`) on the Windows runner.

![Terraform Plan step](../outputs%20pics/Project%2012/Screenshot%202026-11-20%20211522.png)

## Challenges
- **Run #1 failed:** the first run ("pic update") failed. [Add the cause from the run logs.]
  The next commit ("update the .tf") fixed it, and run #2 succeeded.
- **Working directory:** the workflow runs in the repo root, but the Terraform code is in project folders
  (for example `Project 1/`). To plan a specific project, set a working directory:

  ```yaml
  defaults:
    run:
      working-directory: 'Project 1'
  ```
  and set the artifact `path` to match (for example `Project 1/tfplan`).

## Result
Set up a GitHub Actions CI pipeline that runs Terraform `init`, `validate`, and `plan` on every push to `main`
and saves the plan file as an artifact for review before any changes are applied.