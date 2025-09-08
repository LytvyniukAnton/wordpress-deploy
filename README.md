# WordPress Deployment on AWS with Terraform, Ansible and GitHub Actions

## Overview

This repository shows how to deploy a WordPress website on **AWS EC2** using a fully automated workflow:
- **Terraform** provisions the infrastructure (EC2 instance, security group).
- **Ansible** configures the server (Nginx, PHP, MariaDB, WordPress).
- **GitHub Actions** runs everything automatically on each push to `main`.

The goal is to have a repeatable and simple way to get a working WordPress site online in minutes.

---

## Project Structure

```
.github/workflows/
 ├─ deploy.yml          # GitHub Actions workflow for deployment
 └─ destroy.yml         # Workflow for destroying infrastructure

ansible/
 ├─ roles/
 │   ├─ mariadb/tasks/main.yml
 │   ├─ nginx/
 │   │   ├─ handlers/main.yml
 │   │   ├─ tasks/main.yml
 │   │   └─ templates/default.conf.j2
 │   ├─ php/tasks/main.yml
 │   └─ wordpress/
 │       ├─ tasks/main.yml
 │       └─ templates/wp-config.php.j2
 └─ wordpress_deploy.yml  # Main Ansible playbook

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

1. **Terraform** creates:
   - An EC2 instance
   - A security group with inbound rules for SSH, HTTP, HTTPS

2. **Ansible** configures the instance:
   - Installs and sets up MariaDB
   - Installs and configures Nginx with SSL
   - Installs PHP with necessary extensions
   - Downloads and configures WordPress

3. **GitHub Actions** automates everything:
   - On push to `main`, it runs `terraform apply` to provision infra
   - Then runs Ansible to configure the server
   - The public IP of the WordPress site is available in the workflow logs

---

## Usage

1. Clone this repository.
2. Push it to your own GitHub repository.
3. Add the required secrets in **Settings → Secrets → Actions**.
4. Push any change to `main`.
5. Watch the workflow run under the **Actions** tab.
6. After successful deployment, grab the public IP from the Terraform outputs and open it in your browser — you should see the WordPress setup page.

---

## Destroying the Infrastructure

If you want to tear everything down, run the `destroy.yml` workflow in GitHub Actions.  
This executes `terraform destroy` and removes all AWS resources created by this project.