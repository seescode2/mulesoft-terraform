# Lab 3: Inventory environments

## Goal

Query environments in a business group and practice headers, typed variables,
conditional collection filtering, and stable minimal outputs.

## Run the lab

```bash
cd 03-environment-inventory
cp terraform.tfvars.example terraform.tfvars
# Edit the ignored file with a token and the ID from lab 2.
terraform init
terraform plan
terraform apply
terraform output -json environments
```

Optionally set `environment_type = "sandbox"`. Save an environment ID for later
labs. Cleanup with `terraform destroy`.

## Extension

Environment creation/deletion is deliberately omitted: it changes shared
access boundaries even when it has no direct infrastructure cost. In a governed
account, model it with a provider resource or approved REST resource, import any
existing environment first, require review of the plan, and protect production
with lifecycle safeguards.
