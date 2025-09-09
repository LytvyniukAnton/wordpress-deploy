# WordPress Deployment on AWS with Terraform, Ansible and GitHub Actions

## Overview

This repository shows how to deploy a WordPress website on **AWS EC2** using a fully automated CI/CD workflow:
- **Terraform** provisions the infrastructure (EC2 instance, security group).
- **Ansible** configures the server (Nginx, PHP, MariaDB, WordPress).
- **GitHub Actions** runs automated checks on the `dev` branch and deploys automatically on each push to `main`.

The goal is to have a repeatable and simple way to get a working WordPress site online in minutes, with a robust testing and deployment pipeline.

---

## Project Structure

```

.github/workflows/
 ├─ deploy.yml          \# GitHub Actions workflow for production deployment
 ├─ destroy.yml         \# Workflow for destroying infrastructure
 └─ test.yml            \# Workflow for running tests on dev branch and pull requests

ansible/
 ├─ roles/
 │   ├─ mariadb/tasks/main.yml
 │   ├─ nginx/
 │   │   ├─ handlers/main.yml
 │   │   ├─ tasks/main.yml
 │   │   └─ templates/default.conf.j2
 │   ├─ php/tasks/main.yml
 │   └─ wordpress/
 │       ├─ tasks/main.yml
 │       └─ templates/wp-config.php.j2
 └─ wordpress\_deploy.yml  \# Main Ansible playbook

terraform/
 ├─ ec2.tf
 ├─ main.tf
 ├─ outputs.tf
 ├─ provider.tf
 ├─ security-group.tf
 └─ variables.tf

.gitignore
README.md

```

---

## Prerequisites

1. AWS account.
2. S3 bucket for Terraform remote state.
3. DynamoDB table named `terraform-locks` for state locking.
4. An EC2 key pair for SSH access.
5. GitHub repository with this code.
6. Configure these GitHub secrets in your repo:
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
    * All changes are pushed to the `dev` branch.
    * A push to `dev` triggers the `test.yml` workflow, which runs `terraform plan` and other checks.
    * This ensures that changes are validated before being merged into `main`.

2. **Deployment (`main` branch)**:
    * A pull request is created from `dev` to `main`.
    * All required checks from the `test.yml` workflow must pass before the pull request can be merged.
    * A merge to `main` triggers the `deploy.yml` workflow, which runs `terraform apply` and the Ansible playbook to provision and configure the production environment.

3. **Terraform** creates:
   - An EC2 instance
   - A security group with inbound rules for SSH, HTTP, HTTPS

4. **Ansible** configures the instance:
   - Installs and sets up MariaDB
   - Installs and configures Nginx with SSL
   - Installs PHP with necessary extensions
   - Downloads and configures WordPress

---

## Usage

1. Clone this repository.
2. Push it to your own GitHub repository.
3. Add the required secrets in **Settings → Secrets → Actions**.
4. Create a new `dev` branch and make all your changes there.
5. Push changes to `dev` and watch the `test.yml` workflow run under the **Actions** tab.
6. Create a Pull Request from `dev` to `main`. Ensure all checks pass.
7. Merge the Pull Request. The `deploy.yml` workflow will automatically run.
8. After successful deployment, grab the public IP from the Terraform outputs and open it in your browser — you should see the WordPress setup page.

---

## Destroying the Infrastructure

If you want to tear everything down, run the `destroy.yml` workflow in GitHub Actions.
This executes `terraform destroy` and removes all AWS resources created by this project.
```