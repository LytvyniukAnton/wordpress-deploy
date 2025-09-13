# WordPress Deployment on AWS with Terraform, Ansible and GitHub Actions

## Overview

This repository shows how to deploy a WordPress website on **AWS EC2** using
a fully automated CI/CD workflow:

- **Terraform** provisions the infrastructure (EC2 instance, security group).
- **Ansible** configures the server (Nginx, PHP, MariaDB, WordPress).
- **GitHub Actions** runs automated checks on pull requests and deploys
  automatically on each push to `main`.

The goal is to have a repeatable and simple way to get a working WordPress
site online in minutes, with a robust testing and deployment pipeline.

> [!NOTE]
> This project is intended as an educational example of how to combine Terraform, Ansible, and GitHub Actions for WordPress deployment.

---

## Project Structure

```text
.github/workflows/
├─ deploy.yml         # Deploy workflow
├─ destroy.yml        # Destroy infrastructure
└─ test.yml           # PR checks

ansible/
├─ wordpress_deploy.yml
├─ roles/
│  ├─ aapanel/tasks/main.yml
│  ├─ common/tasks/main.yml
│  ├─ docker/tasks/main.yml
│  ├─ mariadb/tasks/main.yml
│  ├─ nginx/
│  │  ├─ handlers/main.yml
│  │  ├─ tasks/main.yml
│  │  └─ templates/default.conf.j2
│  ├─ php/
│  │  ├─ handlers/main.yml
│  │  ├─ tasks/main.yml
│  │  └─ templates/www.conf.j2
│  └─ wordpress/
│     ├─ tasks/main.yml
│     └─ templates/wp-config.php.j2

terraform/
├─ ec2.tf
├─ main.tf
├─ outputs.tf
├─ provider.tf
├─ security-group.tf
├─ variables.tf
└─ terraform.tfvars

.gitignore
README.md
```

> [!TIP]
> You can extend this structure by adding more Ansible roles or Terraform modules as your infrastructure grows.

---

## Prerequisites

> [!NOTE]
> Before you begin, ensure you have a GitHub repository with this code. You will
> need to configure a series of GitHub secrets with your AWS credentials
> and other sensitive information.

1. AWS account.
1. S3 bucket for Terraform remote state.
1. DynamoDB table named `terraform-locks` for state locking.
1. An EC2 key pair for SSH access.
1. GitHub repository with this code.
1. Configure these GitHub secrets in your repo:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_KEY_NAME`
   - `ALLOWED_IPS` (e.g. `["0.0.0.0/0"]`)
   - `SSH_PRIVATE_KEY`
   - `ANSIBLE_VAULT_PASS` (optional, if using Vault)
   - `DB_ROOT_PASSWORD`
   - `DB_PASSWORD`

---

## How It Works

1. **Development (`dev` branch)**:
   - All changes are pushed to the `dev` branch.
   - A pull request is created from `dev` to `main`. This action triggers the
     `test.yml` workflow, which runs automated checks.
   - This ensures that changes are validated before being merged into `main`.

1. **Deployment (`main` branch)**:
   - A pull request is created from `dev` to `main`.
   - All required checks from the `test.yml` workflow must pass before the
     pull request can be merged.

> [!IMPORTANT]
> The `main` branch is considered your production environment. Any merge into
> this branch will trigger a full deployment of your infrastructure and
> application.

- A merge to `main` triggers the `deploy.yml` workflow, which runs
  `terraform apply` and the Ansible playbook to provision and configure the
  production environment.

> [!IMPORTANT]
> Always review the Terraform plan carefully before applying changes to production.

1. **Terraform** creates:
   - An EC2 instance
   - A security group with inbound rules for SSH, HTTP, HTTPS

1. **Ansible** configures the instance:
   - Installs and sets up MariaDB
   - Installs and configures Nginx with SSL
   - Installs PHP with necessary extensions
   - Downloads and configures WordPress
   - Sets up Docker and aaPanel

---

## Testing Workflow Details

The `test.yml` workflow runs a series of checks on every pull request to ensure that
infrastructure and configuration changes are valid and safe.

- **Terraform Validate**: This is a fast, static check that validates the syntax
  and configuration of the Terraform files. It confirms that the code is
  correctly written before attempting a more complex plan.
- **Terraform Plan Check**: This job generates an execution plan of all
  infrastructure changes without applying them. It shows exactly what resources
  will be added, changed, or destroyed, helping to catch unintended consequences
  before they are deployed.
- **Ansible Lint**: This check validates the syntax and style of all Ansible
  playbooks and roles. It helps to catch common errors and enforces best
  practices, ensuring that your configuration code is clean and readable.

> [!NOTE]
> These checks run automatically on pull requests, so you don’t need to trigger them manually.

---

## How to enable auto-merge

For a fully automated workflow, you can enable auto-merge for your pull requests.
This feature allows GitHub to automatically merge your changes into `main` once
all required checks and reviews have been approved.

1. **Enable auto-merge in your repository settings**: Go to **Settings** >
   **General** > **Pull requests** and check **"Allow auto-merge"**.
1. **Enable on the pull request**: After creating a pull request, you will see
   the option to **"Enable auto-merge"** in the sidebar.

This feature, combined with your **branch protection rules**, ensures that only
validated and approved code is merged into your production branch, minimizing the
risk of errors.

---

## Usage

1. Clone this repository.
1. Push it to your own GitHub repository.
1. Add the required secrets in **Settings → Secrets → Actions**.

> [!CAUTION]
> The `ALLOWED_IPS` secret should be configured with a specific IP address
> or CIDR block to limit SSH and web access for security. Using `0.0.0.0/0`
> is not recommended for production environments.

1. **Configure Branch Protection Rules**:
   - Go to **Settings → Branches** and create a new rule for the `main` branch.
   - Select **"Require a pull request before merging"** and **"Require status
     checks to pass before merging"**.
   - Add the following required status checks: `Terraform Plan Check`,
     `Terraform Validate`, and `Ansible Lint`.
   - Optionally, you can also enable **"Allow auto-merge"** in your repository's
     **Pull requests** settings.

1. Create a new `dev` branch and make all your changes there.
1. Push changes to `dev`.
1. Create a Pull Request from `dev` to `main`. A new workflow run will appear
   under the **Actions** tab. Ensure all checks pass.
1. Merge the Pull Request. The `deploy.yml` workflow will automatically run.
1. After successful deployment, grab the public IP from the Terraform outputs
   and open it in your browser — you should see the WordPress setup page.
   `Access WordPress: https://<EC2_PUBLIC_IP>/`
1. `Access aaPanel: https://<EC2_PUBLIC_IP>/aapanel/`

> [!TIP]
> You can find the public IP in the logs of the `terraform` job in your
> `deploy.yml` workflow.

---

## Destroying the Infrastructure

If you want to tear everything down, run the `destroy.yml` workflow in GitHub Actions.

> [!WARNING]
> This action is permanent and will remove all AWS resources created by this project,
> including your EC2 instance, database, and all associated data.
> Use with caution.

> [!CAUTION]
> Destroying infrastructure will also delete all WordPress content stored on the instance unless you use external storage or backups.

This executes `terraform destroy` and removes all AWS resources created by this project.
