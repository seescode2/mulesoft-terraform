# Lab 7: Access-management inventory

## Goal

Build a small, read-only access review and avoid exposing unnecessary personal
data by outputting only counts and disabled usernames.

## Run the lab

```bash
cd 07-access-management-inventory
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
terraform output access_review
terraform destroy
```

This endpoint usually requires organization-administrator privileges. If your
free account does not grant them, treat a 403 as expected and review the
configuration without applying.

## Production capability map

Governed Terraform can automate users, teams, role assignments, connected apps,
client credentials, and identity-provider settings. Keep credentials in a
secret manager, use least privilege, avoid outputting secrets, separate duties,
and review destructive access changes outside Terraform before apply.
